import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'featured_products/custom_horizontal_products_list_widget.dart';

class FeaturedProductsListSliver extends StatelessWidget {
  const FeaturedProductsListSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListenableBuilder(
          listenable: homeData,
          builder: (context, child) {
            if (!homeData.isFeaturedProductInitial &&
                homeData.featuredProductList.isEmpty) return const SizedBox();
            return CustomHorizontalProductsListSectionWidget(
              title: 'featured_products_ucf'.tr(context: context),
              isProductInitial: homeData.isFeaturedProductInitial,
              productList: homeData.featuredProductList,
              numberOfTotalProducts: homeData.totalFeaturedProductData,
              onArriveTheEndOfList: homeData.fetchFeaturedProducts,
            );
          }),
    );
  }
}
