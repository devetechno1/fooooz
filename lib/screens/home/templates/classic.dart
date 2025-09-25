// import statements
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/all_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/auction_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/best_selling_section_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/brand_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/build_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_category/feautured_category_horizontal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/new_products_list_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/product_loading_container.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/today_deal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/whatsapp_floating_widget.dart';
import 'package:flutter/material.dart';
import '../../../custom/home_banners/home_banners_list.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../services/push_notification_service.dart';
import '../home.dart';
import '../widgets/featured_products_list_sliver.dart';
import '../widgets/flash_sale.dart';

class ClassicScreen extends StatefulWidget {
  const ClassicScreen({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _ClassicScreenState createState() => _ClassicScreenState();
}

class _ClassicScreenState extends State<ClassicScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (OtherConfig.USE_PUSH_NOTIFICATION)
          PushNotificationService.updateDeviceToken();
        homeData.onRefresh();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.go_back,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: homeData,
          builder: (context, child) {
            return Scaffold(
              floatingActionButton: whatsappFloatingButtonWidget,
              appBar: BuildAppBar(context: context),
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: homeData.onRefresh,
                    displacement: 0,
                    child: NotificationListener<ScrollUpdateNotification>(
                      onNotification: (notification) {
                        homeData.paginationListener(notification.metrics);
                        return false;
                      },
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate([
                              AppConfig.purchase_code == ""
                                  ? PiratedWidget(homeData: homeData)
                                  : const SizedBox(),
                              const SizedBox(height: 10),

                              // Header Banner
                              HomeCarouselSlider(homeData: homeData),
                              const SizedBox(height: 16),

                              const FlashSale(
                                isCircle: true,
                                backgroundColor: Colors.white,
                              ),
                            ]),
                          ),
                          //move banner
                          SliverList(
                            delegate: SliverChildListDelegate([
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              //   child: Image.network("https://fooooz.com/public/uploads/all/Ryto4mRZFjxR8INkhLs1DFyX6eoamXKIxXEDFBZM.png"),//TODO:# banner
                              // ),
                              TodaysDealProductsWidget(
                                homePresenter: homeData,
                              ),
                            ]),
                          ),
                          //Featured category-----------------------
                          const CategoryList(),

                          //BannerList---------------------

                          SliverToBoxAdapter(
                            child: HomeBannersList(
                              bannersImagesList: homeData.bannerOneImageList,
                              isBannersInitial: homeData.isBannerOneInitial,
                            ),
                          ),
                          //  SliverToBoxAdapter(
                          //   child: HomeBannersListCircle(
                          //     bannersImagesList: homeData.bannerOneImageList,
                          //     isBannersInitial: homeData.isBannerOneInitial,
                          //   ),
                          // ),
                          //featuredProducts-----------------------------
                          const FeaturedProductsListSliver(),
                          //BannerList---------------------
                          SliverToBoxAdapter(
                            child: HomeBannersList(
                              bannersImagesList: homeData.bannerTwoImageList,
                              isBannersInitial: homeData.isBannerTwoInitial,
                            ),
                          ),

                          //Best Selling-------------------
                          // if(homeData.isFeaturedProductInitial || homeData.featuredProductList.isNotEmpty)
                          const BestSellingSectionSliver(),
                          //newProducts-----------------------------
                          const NewProductsListSliver(),
                          //BannerList---------------------
                          SliverToBoxAdapter(
                            child: HomeBannersList(
                              bannersImagesList: homeData.bannerThreeImageList,
                              isBannersInitial: homeData.isBannerThreeInitial,
                            ),
                          ),

                          //auction products----------------------------
                          AuctionProductsSectionSliver(
                            homeData: homeData,
                          ),
                          //Brand List ---------------------------
                          if (homeData.isBrandsInitial ||
                              homeData.brandsList.isNotEmpty)
                            BrandListSectionSliver(homeData: homeData),
                          //all products --------------------------
                          ...allProductsSliver(context, homeData),

                          ///
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ProductLoadingContainer(homeData: homeData),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // AppBar buildAppBar(double statusBarHeight, BuildContext context) {
  //   return AppBar(
  //     automaticallyImplyLeading: false,
  //     backgroundColor: Colors.white,
  //     scrolledUnderElevation: 0.0,
  //     centerTitle: false,
  //     elevation: 0,
  //     flexibleSpace: Padding(
  //       padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => const Filter()));
  //         },
  //         child: HomeSearchBox(context: context),
  //       ),
  //     ),
  //   );
  // }
}
