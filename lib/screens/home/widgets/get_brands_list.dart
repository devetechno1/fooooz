import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/custom_horizontal_brands_list.dart';
import 'package:flutter/material.dart';

import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import '../home.dart';

// TODO:# change to new products not featured

class GetBrandsListSliver extends StatelessWidget {
  const GetBrandsListSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListenableBuilder(
          listenable: homeData,
          builder: (context, child) {
            // if (!homeData.isFeaturedProductInitial && homeData.featuredProductList.isEmpty) return const SizedBox();
            return CustomHorizontalBrandsListSectionWidget(
              title: 'top_brands_ucf'.tr(context: context),
              isBrandsInitial: homeData.isBrandsInitial,
              brandsList: homeData.brandsList,
              numberOfTotalBrands: homeData.totalAllBrandsData,
              onArriveTheEndOfList: homeData.fetchBrandsProducts,

              //  nameTextStyle: ,
              //pricesTextStyle:
            );
          }),
    );
  }
}
