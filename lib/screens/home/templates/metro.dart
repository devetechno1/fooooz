// import statements
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/all_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/auction_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/best_selling_section_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/brand_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/build_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_category/feautured_category_horizontal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/flash_sale.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/product_loading_container.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/today_deal.dart';
import 'package:flutter/material.dart';
import '../../../custom/home_banners/home_banners_list.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../services/push_notification_service.dart';
import '../home.dart';
import '../widgets/featured_products_list_sliver.dart';
import '../widgets/whatsapp_floating_widget.dart';

class MetroScreen extends StatefulWidget {
  const MetroScreen({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _MetroScreenState createState() => _MetroScreenState();
}

class _MetroScreenState extends State<MetroScreen>
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

                              // Flash Sale Section
                              const FlashSale(isCircle: true)
                            ]),
                          ),
                          //move banner
                          SliverList(
                            delegate: SliverChildListDelegate([
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              //   child: Image.network("https://sellerwise.devefinance.com/public/uploads/all/Ryto4mRZFjxR8INkhLs1DFyX6eoamXKIxXEDFBZM.png"),//TODO:# banner
                              // ),
                              TodaysDealProductsWidget(
                                homePresenter: homeData,
                              ),
                            ]),
                          ),
                          //Featured category-----------------------
                          const CategoryList(),
                          // const CategoryListVertical(crossAxisCount: 3,),

                          //BannerList---------------------

                          SliverToBoxAdapter(
                            child: HomeBannersList(
                              bannersImagesList: homeData.bannerOneImageList,
                              isBannersInitial: homeData.isBannerOneInitial,
                            ),
                          ),
                          //featuredProducts-----------------------------
                          const FeaturedProductsListSliver(),
                          //  BannerList---------------------
                          SliverToBoxAdapter(
                            child: HomeBannersList(
                              bannersImagesList: homeData.bannerTwoImageList,
                              isBannersInitial: homeData.isBannerTwoInitial,
                            ),
                          ),
                          //  HomeBannersAnimated(bannersImagesList: homeData.bannerTwoImageList),
                          // SliverToBoxAdapter(
                          //   child: HomeBannersAnimated(
                          //     bannersImagesList: homeData.bannerTwoImageList,
                          //     isBannersInitial: homeData.isBannerTwoInitial,
                          //   ),
                          // ),
                          // HomeBannersAnimated(bannersImagesList: homeData.bannerTwoImageList),
                          // SliverToBoxAdapter(
                          //   child: HomeBannersListAnimation(
                          //     bannersImagesList: homeData.bannerTwoImageList,
                          //     isBannersInitial: homeData.isBannerTwoInitial,
                          //   ),
                          // ),
                          //SliverToBoxAdapter(child: BannerHome(isBannersInitial: homeData.isBannerTwoInitial, bannersImagesList: homeData.bannerTwoImageList)),

                          //Best Selling-------------------
                          // if(homeData.isFeaturedProductInitial || homeData.featuredProductList.isNotEmpty)
                          const BestSellingSectionSliver(),
                          // const VerticalProductsSectionSliver(),
                          //auction products----------------------------
                          AuctionProductsSectionSliver(
                            homeData: homeData,
                          ),
                          //Brand List ---------------------------
                          if (homeData.isBrandsInitial ||
                              homeData.brandsList.isNotEmpty)
                            BrandListSectionSliver(
                              homeData: homeData,
                            ),
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

  // Widget timerCircularContainer(int currentValue, int totalValue, String timeText) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       SizedBox(
  //         width: 30,
  //         height: 30,
  //         child: CircularProgressIndicator(
  //           value: currentValue / totalValue,
  //           backgroundColor: const Color.fromARGB(255, 240, 220, 220),
  //           valueColor: const AlwaysStoppedAnimation<Color>(
  //               Color.fromARGB(255, 255, 80, 80)),
  //           strokeWidth: 4.0,
  //           strokeCap: StrokeCap.round,
  //         ),
  //       ),
  //       Text(
  //         timeText,
  //         style: const TextStyle(
  //           color: Color.fromARGB(228, 218, 29, 29),
  //           fontSize: 10.0,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget buildTimerRow(CurrentRemainingTime time) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
  //     child: Row(
  //       children: [
  //         const Spacer(),

  //         Column(
  //           children: [
  //             timerCircularContainer(time.days, 365, timeText((time.days).toString(), default_length: 3)),
  //             const SizedBox(height: 5),
  //             Text('days'.tr(context: context), style: const TextStyle(color: Colors.grey, fontSize: 10))
  //           ],
  //         ),
  //         const SizedBox(width: 12),
  //         Column(
  //           children: [
  //             timerCircularContainer(time.hours, 24, timeText((time.hours).toString(), default_length: 2)),
  //             const SizedBox(height: 5),
  //             Text('hours'.tr(context: context), style: const TextStyle(color: Colors.grey, fontSize: 10))
  //           ],
  //         ),
  //         const SizedBox(width: 10),
  //         Column(
  //           children: [
  //             timerCircularContainer(time.min, 60, timeText((time.min).toString(), default_length: 2)),
  //             const SizedBox(height: 5),
  //             Text('minutes'.tr(context: context), style: const TextStyle(color: Colors.grey, fontSize: 10))
  //           ],
  //         ),
  //         const SizedBox(width: 5),
  //         Column(
  //           children: [
  //             timerCircularContainer(time.sec, 60, timeText((time.sec).toString(), default_length: 2)),
  //             const SizedBox(height: 5),
  //             Text('seconds'.tr(context: context), style: const TextStyle(color: Colors.grey, fontSize: 10))
  //           ],
  //         ),
  //         const SizedBox(width: 10),
  //         const Column(
  //           children: [
  //           ///  Image.asset("assets/flash_deal.png", height: 20, color: MyTheme.golden),
  //             SizedBox(height: 12),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text('shop_more_ucf'.tr(context: context), style: const TextStyle(fontSize: 10, color: Color(0xffA8AFB3))),
  //             const SizedBox(width: 3),
  //             const Icon(Icons.arrow_forward_outlined, size: 10, color: MyTheme.grey_153),
  //             const SizedBox(width: 10),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

//   String timeText(String val, {int default_length = 2}) {
//     return val.padLeft(default_length, '0');
//   }
}
