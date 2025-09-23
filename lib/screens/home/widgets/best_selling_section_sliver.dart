import 'package:active_ecommerce_cms_demo_app/screens/home/home.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_products/custom_horizontal_products_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class BestSellingSectionSliver extends StatelessWidget {
  const BestSellingSectionSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListenableBuilder(
          listenable: homeData,
          builder: (context, child) {
            if (!homeData.isBestSellingProductInitial &&
                homeData.bestSellingProductList.isEmpty)
              return const SizedBox();
            return CustomHorizontalProductsListSectionWidget(
              title: 'best_selling'.tr(context: context),
              isProductInitial: homeData.isBestSellingProductInitial,
              productList: homeData.bestSellingProductList,
              numberOfTotalProducts: homeData.totalBestSellingProductData,
              onArriveTheEndOfList: homeData.fetchBestSellingProducts,
            );
          }),
    );
  }
}
