import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';

import '../helpers/shimmer_helper.dart';
import '../presenter/home_presenter.dart';
import '../ui_elements/product_card.dart';

class HomeAllProducts extends StatelessWidget {
  final BuildContext? context;
  final HomePresenter? homeData;
  const HomeAllProducts({
    Key? key,
    this.context,
    this.homeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (homeData!.isAllProductInitial && homeData!.allProductList.isEmpty) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildProductGridShimmer(),
      );
    } else if (homeData!.allProductList.isNotEmpty) {
      //snapshot.hasData

      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: homeData!.allProductList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.618),
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
            id: homeData!.allProductList[index].id,
            slug: homeData!.allProductList[index].slug ?? '',
            image: homeData!.allProductList[index].thumbnail_image,
            name: homeData!.allProductList[index].name,
            main_price: homeData!.allProductList[index].main_price,
            stroked_price: homeData!.allProductList[index].stroked_price,
            has_discount: homeData!.allProductList[index].has_discount == true,
            discount: homeData!.allProductList[index].discount,
            isWholesale: null,
          );
        },
      );
    } else if (homeData!.totalAllProductData == 0) {
      return Center(
          child: Text('no_product_is_available'.tr(context: context)));
    } else {
      return Container(); // should never be happening
    }
  }
}
