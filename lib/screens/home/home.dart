// ignore_for_file: non_constant_identifier_names

import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/flash%20deals%20banner/flash_deal_banner.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/build_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_products_list_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_category/feautured_category_horizontal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/menu_item_list.dart';

import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:go_router/go_router.dart';
import '../../custom/home_all_products_2.dart';
import '../../custom/home_banners/home_banners_list.dart';
import '../../custom/home_carousel_slider.dart';
import '../../custom/pirated_widget.dart';
import '../../other_config.dart';
import '../../services/push_notification_service.dart';

HomePresenter homeData = HomePresenter();

class Home extends StatefulWidget {
  const Home({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
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
    // ignore: deprecated_member_use
    return PopScope(
      canPop: widget.go_back,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: homeData,
          builder: (context, child) {
            return Scaffold(
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
                              if (AppConfig.purchase_code == "")
                                PiratedWidget(homeData: homeData),

                              const SizedBox(height: 10),

                              //Header Search
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 20),
                              //   child: HomeSearchBox(),
                              // ),
                              // SizedBox(height: 8),
                              //Header Banner
                              HomeCarouselSlider(homeData: homeData),
                              const SizedBox(height: 16),

                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppDimensions.paddingDefault),
                                child: MenuItemList(),
                              ),
                              // SizedBox(height: 16),

                              //Home slider one
                              HomeBannersList(
                                bannersImagesList: homeData.bannerOneImageList,
                                isBannersInitial: homeData.isBannerOneInitial,
                              ),
                            ]),
                          ),

                          //Featured Categories
                          const CategoryList(),
                          // const  CategoryListVertical(crossAxisCount: 5,),

                          if (homeData.isFlashDeal)
                            SliverList(
                                delegate: SliverChildListDelegate([
                              InkWell(
                                onTap: () =>
                                    GoRouter.of(context).go('/flash-deals'),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    'flash_deals_ucf'.tr(context: context),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              FlashDealBanner(
                                context: context,
                                homeData: homeData,
                              ),
                            ])),

                          // SliverList(
                          //     delegate: SliverChildListDelegate([
                          //   FlashDealBanner(
                          //     context: context,
                          //     homeData: homeData,
                          //   ),
                          // ])),

                          //Featured Products
                          const FeaturedProductsListSliver(),
                          //Home Banner Slider Two
                          // SliverList(
                          //   delegate: SliverChildListDelegate([
                          //     HomeBannerTwo(
                          //       context: context,
                          //       homeData: homeData,
                          //     ),
                          //   ]),
                          // ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.fromLTRB(18.0, 20, 20.0, 0.0),
                            sliver: SliverToBoxAdapter(
                              child: Text(
                                'all_products_ucf'.tr(context: context),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),

                          //Home All Product
                          HomeAllProductsSliver(homeData: homeData),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: buildProductLoadingContainer(homeData),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container buildProductLoadingContainer(HomePresenter homeData) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          homeData.totalAllProductData == homeData.allProductList.length
              ? 'no_more_products_ucf'.tr(context: context)
              : 'loading_more_products_ucf'.tr(context: context),
        ),
      ),
    );
  }
}
