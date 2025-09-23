import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/btn.dart';
import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/reg_ex_inpur_formatter.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/string_helper.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/brand_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/category_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/product_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/shop_repository.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/brand_square_card.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/product_card.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/shop_square_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../data_model/search_suggestion_response.dart';
import '../repositories/search_repository.dart';
import '../ui_elements/highlighted_searched_word.dart';

class WhichFilter {
  String option_key;
  String name;

  WhichFilter(this.option_key, this.name);

  static List<WhichFilter> getWhichFilterList() {
    return <WhichFilter>[
      WhichFilter('product', 'product_ucf'.tr()),
      WhichFilter('sellers', 'sellers_ucf'.tr()),
      WhichFilter('brands', 'brands_ucf'.tr()),
    ];
  }
}

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
    this.selected_filter = "product",
  }) : super(key: key);

  final String selected_filter;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  final ScrollController _productScrollController = ScrollController();
  final ScrollController _brandScrollController = ScrollController();
  final ScrollController _shopScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController? _scrollController;
  WhichFilter? _selectedFilter;
  String? _givenSelectedFilterOptionKey; // may be it can come from another page
  String? _selectedSort = "";

  final List<WhichFilter> _which_filter_list = WhichFilter.getWhichFilterList();
  List<DropdownMenuItem<WhichFilter>>? _dropdownWhichFilterItems;
  final List<dynamic> _selectedCategories = [];
  final List<dynamic> _selectedBrands = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  //--------------------
  final List<dynamic> _filterBrandList = [];
  final List<dynamic> _filterCategoryList = [];

  final List<dynamic> _searchSuggestionList = [];

  //----------------------------------------
  String? _searchKey = "";

  final List<dynamic> _productList = [];
  bool _isProductInitial = true;
  int _productPage = 1;
  int? _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  final List<dynamic> _brandList = [];
  bool _isBrandInitial = true;
  int _brandPage = 1;
  int? _totalBrandData = 0;
  bool _showBrandLoadingContainer = false;

  final List<dynamic> _shopList = [];
  bool _isShopInitial = true;
  int _shopPage = 1;
  int? _totalShopData = 0;
  bool _showShopLoadingContainer = false;

  //----------------------------------------

  fetchFilteredBrands() async {
    final filteredBrandResponse = await BrandRepository().getFilterPageBrands();
    _filterBrandList.addAll(filteredBrandResponse.brands!);
    setState(() {});
  }

  fetchFilteredCategories() async {
    final filteredCategoriesResponse =
        await CategoryRepository().getFilterPageCategories();
    _filterCategoryList.addAll(filteredCategoriesResponse.categories!);
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productScrollController.dispose();
    _brandScrollController.dispose();
    _shopScrollController.dispose();
    super.dispose();
  }

  init() {
    _givenSelectedFilterOptionKey = widget.selected_filter;

    _dropdownWhichFilterItems =
        buildDropdownWhichFilterItems(_which_filter_list);
    _selectedFilter = _dropdownWhichFilterItems![0].value;

    for (int x = 0; x < _dropdownWhichFilterItems!.length; x++) {
      if (_dropdownWhichFilterItems![x].value!.option_key ==
          _givenSelectedFilterOptionKey) {
        _selectedFilter = _dropdownWhichFilterItems![x].value;
      }
    }

    fetchFilteredCategories();
    fetchFilteredBrands();

    if (_selectedFilter!.option_key == "sellers") {
      fetchShopData();
    } else if (_selectedFilter!.option_key == "brands") {
      fetchBrandData();
    } else {
      fetchProductData();
    }

    //set scroll listeners

    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
          _brandScrollController.position.maxScrollExtent) {
        setState(() {
          _brandPage++;
        });
        _showBrandLoadingContainer = true;
        fetchBrandData();
      }
    });

    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        setState(() {
          _shopPage++;
        });
        _showShopLoadingContainer = true;
        fetchShopData();
      }
    });
  }

  fetchProductData() async {
    final productResponse = await ProductRepository().getFilteredProducts(
        page: _productPage,
        name: _searchKey,
        sort_key: _selectedSort,
        brands: _selectedBrands.join(",").toString(),
        categories: _selectedCategories.join(",").toString(),
        max: _maxPriceController.text.toString(),
        min: _minPriceController.text.toString());

    _productList.addAll(productResponse.products!);
    _isProductInitial = false;
    _totalProductData = productResponse.meta!.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchBrandData() async {
    final brandResponse =
        await BrandRepository().getBrands(page: _brandPage, name: _searchKey);
    _brandList.addAll(brandResponse.brands!);
    _isBrandInitial = false;
    _totalBrandData = brandResponse.meta!.total;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  resetBrandList() {
    _brandList.clear();
    _isBrandInitial = true;
    _totalBrandData = 0;
    _brandPage = 1;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  fetchShopData() async {
    final shopResponse =
        await ShopRepository().getShops(page: _shopPage, name: _searchKey);
    _shopList.addAll(shopResponse.shops);
    _isShopInitial = false;
    _totalShopData = shopResponse.meta.total;
    _showShopLoadingContainer = false;
    //print("_shopPage:" + _shopPage.toString());
    //print("_totalShopData:" + _totalShopData.toString());
    setState(() {});
  }

  reset() {
    _searchSuggestionList.clear();
    setState(() {});
  }

  resetShopList() {
    _shopList.clear();
    _isShopInitial = true;
    _totalShopData = 0;
    _shopPage = 1;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onProductListRefresh() async {
    reset();
    resetProductList();
    fetchProductData();
  }

  Future<void> _onBrandListRefresh() async {
    reset();
    resetBrandList();
    fetchBrandData();
  }

  Future<void> _onShopListRefresh() async {
    reset();
    resetShopList();
    fetchShopData();
  }

  _applyProductFilter() {
    reset();
    resetProductList();
    fetchProductData();
  }

  _onSearchSubmit() {
    reset();
    if (_selectedFilter!.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter!.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  _onSortChange() {
    reset();
    resetProductList();
    fetchProductData();
  }

  _onWhichFilterChange() {
    if (_selectedFilter!.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter!.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  List<DropdownMenuItem<WhichFilter>> buildDropdownWhichFilterItems(
      List whichFilterList) {
    final List<DropdownMenuItem<WhichFilter>> items = [];
    for (WhichFilter which_filter_item
        in whichFilterList as Iterable<WhichFilter>) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }

  Widget buildProductLoadingContainer() {
    if (_totalProductData != _productList.length) return const SizedBox();
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text('no_more_products_ucf'.tr(context: context)),
      ),
    );
  }

  Widget buildBrandLoadingContainer() {
    if (_totalBrandData != _brandList.length) return const SizedBox();
    return Container(
      height: _showBrandLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text('no_more_brands_ucf'.tr(context: context)),
      ),
    );
  }

  Widget buildShopLoadingContainer() {
    if (_totalShopData != _shopList.length) return const SizedBox();
    return Container(
      height: _showShopLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text('no_more_shops_ucf'.tr(context: context)),
      ),
    );
  }

  //--------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        endDrawer: buildFilterDrawer(),
        key: _scaffoldKey,
        backgroundColor: MyTheme.mainColor,
        body: Stack(fit: StackFit.loose, children: [
          _selectedFilter!.option_key == 'product'
              ? buildProductList()
              : (_selectedFilter!.option_key == 'brands'
                  ? buildBrandList()
                  : buildShopList()),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: buildAppBar(context),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: _selectedFilter!.option_key == 'product'
                  ? buildProductLoadingContainer()
                  : (_selectedFilter!.option_key == 'brands'
                      ? buildBrandLoadingContainer()
                      : buildShopLoadingContainer()))
        ]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.mainColor.withValues(alpha: 0.95),
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      forceMaterialTransparency: false,
      actions: const [SizedBox()],
      centerTitle: false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        child: Column(
          children: [
            buildTopAppBar(context),
            buildBottomAppBar(context),
          ],
        ),
      ),
    );
  }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                horizontal: BorderSide(
                  color: MyTheme.light_grey,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            child: DropdownButton<WhichFilter>(
              dropdownColor: Colors.white,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusHalfSmall),
              icon: const Icon(Icons.expand_more_rounded, size: 18),
              hint: Text(
                'products_ucf'.tr(context: context),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 13),
              iconSize: 13,
              underline: const SizedBox(),
              value: _selectedFilter,
              items: _dropdownWhichFilterItems,
              isExpanded: true,
              onChanged: (WhichFilter? selectedFilter) {
                setState(() {
                  _selectedFilter = selectedFilter;
                });

                _onWhichFilterChange();
              },
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _selectedFilter!.option_key == "product"
                  ? _scaffoldKey.currentState!.openEndDrawer()
                  : ToastComponent.showDialog(
                      'you_can_use_sorting_while_searching_for_products'
                          .tr(context: context),
                    );
              ;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: MyTheme.light_grey,
                    width: .5,
                  ),
                  horizontal: BorderSide(color: MyTheme.light_grey, width: 1),
                ),
              ),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'filter_ucf'.tr(context: context),
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  const Icon(Icons.filter_alt_outlined, size: 13),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _selectedFilter!.option_key == "product"
                  ? showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        contentPadding: const EdgeInsets.only(
                          top: 16.0,
                          left: 2.0,
                          right: 2.0,
                          bottom: 2.0,
                        ),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return RadioGroup(
                            groupValue: _selectedSort,
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Text(
                                    'sort_products_by_ucf'
                                        .tr(context: context),
                                  ),
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "",
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    'default_ucf'.tr(context: context),
                                  ),
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "price_high_to_low",
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    'price_high_to_low'
                                        .tr(context: context),
                                  ),
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "price_low_to_high",
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    'price_low_to_high'
                                        .tr(context: context),
                                  ),
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "new_arrival",
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text('new_arrival_ucf'
                                      .tr(context: context)),
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "popularity",
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    'popularity_ucf'.tr(context: context),
                                  ),
                                ),
                                RadioListTile(
                                  dense: true,
                                  value: "top_rated",
                                  activeColor: MyTheme.font_grey,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    'top_rated_ucf'.tr(context: context),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        actions: [
                          Btn.basic(
                            child: Text(
                              'close_all_capital'.tr(context: context),
                              style: const TextStyle(
                                  color: MyTheme.medium_grey),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                          ),
                        ],
                      ))
                  : ToastComponent.showDialog(
                      'you_can_use_filters_while_searching_for_products'
                          .tr(context: context),
                    );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                      vertical:
                          BorderSide(color: MyTheme.light_grey, width: .5),
                      horizontal:
                          BorderSide(color: MyTheme.light_grey, width: 1))),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sort_ucf'.tr(context: context),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(
                    Icons.swap_vert,
                    size: 13,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Row buildTopAppBar(BuildContext context) {
    String searchedWord = '';
    return Row(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            icon: UsefulElements.backButton(),
            onPressed: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * .85,
              height: 70,
              child: Padding(
                  padding: MediaQuery.viewPaddingOf(context).top >
                          30 //MediaQuery.viewPaddingOf(context).top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 0.0)
                      : const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 0.0),
                  child: TypeAheadField<SearchSuggestionResponse>(
                    controller: _searchController,
                    suggestionsCallback: (pattern) async {
                      //return await BackendService.getSuggestions(pattern);
                      final suggestions = await SearchRepository()
                          .getSearchSuggestionListResponse(
                              query_key: pattern,
                              type: _selectedFilter!.option_key);
                      //print(suggestions.toString());
                      return suggestions;
                    },
                    loadingBuilder: (context) {
                      return Container(
                        height: 40,
                        color: Colors.white,
                        child: Center(
                            child: Text(
                                'loading_suggestions'.tr(context: context),
                                style: const TextStyle(
                                    color: MyTheme.medium_grey))),
                      );
                    },
                    itemBuilder: (context, suggestion) {
                      //print(suggestion.toString());
                      String subtitle =
                          "${'searched_for_all_lower'.tr(context: context)} ${suggestion.count} ${'times_all_lower'.tr(context: context)}";
                      if (suggestion.type != "search") {
                        final String key =
                            "${suggestion.type_string?.toLowerCase()}_ucf";
                        final String tr = key.tr(context: context);
                        subtitle =
                            "${tr == key ? suggestion.type_string : tr} ${'found_all_lower'.tr(context: context)}";
                      }
                      final q = suggestion.query ?? '';
                      return Directionality(
                        textDirection: q.direction,
                        child: ListTile(
                          tileColor: Colors.white,
                          dense: true,
                          title: HighlightedSearchedWord(
                            q,
                            searchedText: searchedWord,
                            style: TextStyle(
                              color: suggestion.type != "search"
                                  ? Theme.of(context).primaryColor
                                  : MyTheme.font_grey,
                            ),
                          ),
                          subtitle: Text(
                            subtitle,
                            style: TextStyle(
                              color: suggestion.type != "search"
                                  ? MyTheme.font_grey
                                  : MyTheme.medium_grey,
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (s) => onSearch(s.query ?? ''),
                    builder: (context, controller, focusNode) {
                      searchedWord = controller.text;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        obscureText: false,
                        onChanged: (value) => searchedWord = value,
                        onSubmitted: onSearch,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: MyTheme.white,
                            suffixIcon: const Icon(Icons.search,
                                color: MyTheme.medium_grey),
                            hintText: 'search_here_ucf'.tr(context: context),
                            hintStyle: const TextStyle(
                                fontSize: 12.0, color: MyTheme.textfield_grey),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.noColor, width: 0.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radiusSmall),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.noColor, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radiusSmall),
                              ),
                            ),
                            contentPadding: const EdgeInsetsDirectional.only(
                                start: 8.0, top: 5.0, bottom: 5.0)),
                      );
                    },
                  )),
            ),
          ),
          // IconButton(
          //     icon: Icon(Icons.search, color: MyTheme.dark_grey),
          //     onPressed: () {
          //       _searchKey = _searchController.text.toString();
          //       setState(() {});
          //       _onSearchSubmit();
          //     }),
        ]);
  }

  void onSearch(String query) {
    _searchController.text = query;
    _searchKey = query;
    setState(() {});
    _onSearchSubmit();
  }

  Directionality buildFilterDrawer() {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Drawer(
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimensions.paddingSmall),
                        child: Text(
                          'price_range_ucf'.tr(context: context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingSmall),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _minPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText:
                                        'minimum_ucf'.tr(context: context),
                                    hintStyle: const TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.textfield_grey),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimensions.radiusSmallExtra),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimensions.radiusSmallExtra),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                          const Text(" - "),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingSmall),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _maxPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText:
                                        'maximum_ucf'.tr(context: context),
                                    hintStyle: const TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.textfield_grey),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimensions.radiusSmallExtra),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimensions.radiusSmallExtra),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'categories_ucf'.tr(context: context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterCategoryList.isEmpty
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'no_category_is_available'
                                      .tr(context: context),
                                  style:
                                      const TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text(
                          'brands_ucf'.tr(context: context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.isEmpty
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'no_brand_is_available'.tr(context: context),
                                  style:
                                      const TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterBrandsList(),
                            ),
                    ]),
                  )
                ]),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _minPriceController.clear();
                        _maxPriceController.clear();
                        setState(() {
                          _selectedCategories.clear();
                          _selectedBrands.clear();
                        });
                      },
                      child: Text(
                        'clear_all_capital'.tr(context: context),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        final min = _minPriceController.text.toString();
                        final max = _maxPriceController.text.toString();
                        bool apply = true;
                        if (min != "" && max != "") {
                          if (max.compareTo(min) < 0) {
                            ToastComponent.showDialog(
                              'filter_screen_min_max_warning'
                                  .tr(context: context),
                            );
                            apply = false;
                          }
                        }

                        if (apply) {
                          _applyProductFilter();
                        }
                      },
                      child: Text(
                        'apply_all_capital'.tr(context: context),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildFilterBrandsList() {
    return ListView(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterBrandList
            .map(
              (brand) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(brand.name),
                value: _selectedBrands.contains(brand.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedBrands.add(brand.id);
                    });
                  } else {
                    setState(() {
                      _selectedBrands.remove(brand.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterCategoryList() {
    return ListView(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterCategoryList
            .map(
              (category) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(category.name),
                value: _selectedCategories.contains(category.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedCategories.clear();
                      _selectedCategories.add(category.id);
                    });
                  } else {
                    setState(() {
                      _selectedCategories.remove(category.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  Container buildProductList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildProductScrollableList(),
          )
        ],
      ),
    );
  }

  Widget buildProductScrollableList() {
    if (_isProductInitial && _productList.isEmpty) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.isNotEmpty) {
      final bool hasMoreProducts =
          (_totalProductData ?? 0) > _productList.length;
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: _onProductListRefresh,
        child: SingleChildScrollView(
          controller: _productScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.viewPaddingOf(context).top > 40 ? 150 : 135
                  //MediaQuery.viewPaddingOf(context).top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: hasMoreProducts
                    ? _productList.length + 2
                    : _productList.length,
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.63,  
                ),
                padding: const EdgeInsets.only(
                    top: AppDimensions.paddingSupSmall,
                    bottom: AppDimensions.paddingSupSmall,
                    left: 18,
                    right: 18),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index >= _productList.length) {
                    return ShimmerHelper.shimmerInGrid(index);
                  }
                  // 3
                  return ProductCard(
                    id: _productList[index].id,
                    slug: _productList[index].slug,
                    image: _productList[index].thumbnail_image,
                    name: _productList[index].name,
                    main_price: _productList[index].main_price,
                    stroked_price: _productList[index].stroked_price,
                    has_discount: _productList[index].has_discount,
                    discount: _productList[index].discount,
                    isWholesale: _productList[index].isWholesale,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalProductData == 0) {
      return Center(
          child: Text('no_product_is_available'.tr(context: context)));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildBrandList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildBrandScrollableList(),
          )
        ],
      ),
    );
  }

  Widget buildBrandScrollableList() {
    if (_isBrandInitial && _brandList.isEmpty) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_brandList.isNotEmpty) {
      final bool hasMoreBrands = (_totalBrandData ?? 0) > _brandList.length;
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: _onBrandListRefresh,
        child: SingleChildScrollView(
          controller: _brandScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.viewPaddingOf(context).top > 40 ? 140 : 135
                  //MediaQuery.viewPaddingOf(context).top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _brandList.length + (hasMoreBrands ? 2 : 0),
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1),
                padding: const EdgeInsets.only(
                    top: AppDimensions.paddingLarge,
                    bottom: AppDimensions.paddingSupSmall,
                    left: 18,
                    right: 18),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index >= _brandList.length) {
                    return ShimmerHelper.shimmerInGrid(index);
                  }
                  // 3
                  return BrandSquareCard(
                    id: _brandList[index].id,
                    slug: _brandList[index].slug,
                    image: _brandList[index].logo,
                    name: _brandList[index].name,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalBrandData == 0) {
      return Center(child: Text('no_brand_is_available'.tr(context: context)));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildShopList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildShopScrollableList(),
          )
        ],
      ),
    );
  }

  Widget buildShopScrollableList() {
    if (_isShopInitial && _shopList.isEmpty) {
      return SingleChildScrollView(
          controller: _scrollController,
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_shopList.isNotEmpty) {
      final bool hasMoreShops = (_totalShopData ?? 0) > _shopList.length;
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: _onShopListRefresh,
        child: SingleChildScrollView(
          controller: _shopScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.viewPaddingOf(context).top > 40 ? 140 : 135
                  //MediaQuery.viewPaddingOf(context).top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _shopList.length + (hasMoreShops ? 2 : 0),
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.7),
                padding: const EdgeInsets.only(
                    top: AppDimensions.paddingLarge,
                    bottom: AppDimensions.paddingSupSmall,
                    left: 18,
                    right: 18),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index >= _shopList.length) {
                    return ShimmerHelper.shimmerInGrid(index);
                  }
                  // 3
                  return ShopSquareCard(
                    id: _shopList[index].id,
                    shopSlug: _shopList[index].slug,
                    image: _shopList[index].logo,
                    name: _shopList[index].name,
                    stars: double.parse(_shopList[index].rating.toString()),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalShopData == 0) {
      return Center(child: Text('no_shop_is_available'.tr(context: context)));
    } else {
      return Container(); // should never be happening
    }
  }
}
