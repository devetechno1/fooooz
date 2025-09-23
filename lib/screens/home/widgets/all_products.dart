import 'package:active_ecommerce_cms_demo_app/custom/home_all_products_2.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

List<Widget> allProductsSliver(BuildContext context, HomePresenter homeData) {
  return [
    SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(18.0, 20, 20.0, 0.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'all_products_ucf'.tr(context: context),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    HomeAllProductsSliver(homeData: homeData),
  ];
}
