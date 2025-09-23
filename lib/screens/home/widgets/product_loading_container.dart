import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class ProductLoadingContainer extends StatelessWidget {
  const ProductLoadingContainer({super.key, required this.homeData});

  final HomePresenter homeData;

  @override
  Widget build(BuildContext context) {
    if (homeData.totalAllProductData != homeData.allProductList.length)
      return const SizedBox();
    return Container(
      height: homeData.showAllLoadingContainer ? 40 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(child: Text('no_more_products_ucf'.tr(context: context))),
    );
  }
}
