import 'package:flutter/material.dart';

import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import '../home.dart';
import 'featured_products/custom_horizontal_products_list_widget.dart';

// TODO:# change to new products not featured

class NewProductsListSliver extends StatelessWidget {
  const NewProductsListSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListenableBuilder(
          listenable: homeData,
          builder: (context, child) {
            if (!homeData.isFeaturedProductInitial &&
                homeData.featuredProductList.isEmpty) return const SizedBox();
            return CustomHorizontalProductsListSectionWidget(
              title: 'new_products'.tr(context: context),
              isProductInitial: homeData.isFeaturedProductInitial,
              productList: homeData.featuredProductList,
              numberOfTotalProducts: homeData.totalFeaturedProductData,
              onArriveTheEndOfList: homeData.fetchFeaturedProducts,
              //  nameTextStyle: ,
              //pricesTextStyle:
            );
          }),
    );
  }
}
