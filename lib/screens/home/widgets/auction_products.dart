import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_products/custom_horizontal_products_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class AuctionProductsSectionSliver extends StatelessWidget {
  final HomePresenter homeData;

  const AuctionProductsSectionSliver({
    super.key,
    required this.homeData,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 20, 20.0, 0.0),
                child: SizedBox(
                  width: double.infinity,
                ),
              ),
              CustomHorizontalProductsListSectionWidget(
                title: 'auction_product_ucf'.tr(context: context),
                isProductInitial: homeData.isauctionProductInitial,
                productList: homeData.auctionProductList,
                numberOfTotalProducts: homeData.totalauctionProductData ?? 0,
                onArriveTheEndOfList: homeData.fetchAuctionProducts,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
