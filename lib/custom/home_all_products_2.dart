import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../constants/app_dimensions.dart';
import '../helpers/shimmer_helper.dart';
import '../presenter/home_presenter.dart';
import '../ui_elements/product_card_black.dart';

class HomeAllProductsSliver extends StatelessWidget {
  final HomePresenter homeData;
  const HomeAllProductsSliver({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: AppDimensions.paddingLarge,
        bottom: AppDimensions.paddingSupSmall,
        left: AppDimensions.paddingMedium,
        right: AppDimensions.paddingMedium,
      ),
      sliver: _slivers(context),
    );
  }

  RenderObjectWidget _slivers(BuildContext context) {
    if (homeData.isAllProductInitial) {
      return ShimmerHelper().buildProductSliverGridShimmer();
    } else if (homeData.allProductList.isNotEmpty) {
      final bool isLoadingMore =
          homeData.allProductList.length < homeData.totalAllProductData;
      return SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childCount: isLoadingMore
              ? homeData.allProductList.length + 2
              : homeData.allProductList.length,
          itemBuilder: (context, index) {
            if (index > homeData.allProductList.length - 1) {
              return ShimmerHelper().buildBasicShimmer(height: 200);
            }
            return ProductCardBlack(
              id: homeData.allProductList[index].id,
              slug: homeData.allProductList[index].slug ?? '',
              image: homeData.allProductList[index].thumbnail_image,
              name: homeData.allProductList[index].name,
              main_price: homeData.allProductList[index].main_price,
              stroked_price: homeData.allProductList[index].stroked_price,
              has_discount: homeData.allProductList[index].has_discount == true,
              discount: homeData.allProductList[index].discount,
              isWholesale: homeData.allProductList[index].isWholesale,
            );
          });
    } else if (homeData.totalAllProductData == 0) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text('no_product_is_available'.tr(context: context)),
        ),
      );
    } else {
      return const SliverToBoxAdapter(); // should never be happening
    }
  }
}
