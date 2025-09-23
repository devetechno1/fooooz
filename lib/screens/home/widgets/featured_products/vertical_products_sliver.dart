import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'custom_vertical_products.dart';

class VerticalProductsSectionSliver extends StatelessWidget {
  const VerticalProductsSectionSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListenableBuilder(
        listenable: homeData,
        builder: (context, child) {
          if (!homeData.isFeaturedProductInitial &&
              homeData.featuredProductList.isEmpty) return const SizedBox();
          return CustomVerticalProductsListSectionWidget(
            title: 'featured_products_ucf'.tr(context: context),
            isProductInitial: homeData.isFeaturedProductInitial,
            productList: homeData.featuredProductList,
            numberOfTotalProducts: homeData.totalFeaturedProductData,
            onArriveTheEndOfList: homeData.fetchFeaturedProducts,
          );
        },
      ),
    );
  }
}
