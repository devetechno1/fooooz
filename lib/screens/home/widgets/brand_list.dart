import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/get_brands_widget.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class BrandListSectionSliver extends StatelessWidget {
  final HomePresenter homeData;
  final bool showViewAllButton;

  const BrandListSectionSliver(
      {super.key, required this.homeData, this.showViewAllButton = true});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsetsDirectional.only(
              top: AppDimensions.paddingLarge,
              start: AppDimensions.paddingLarge,
              bottom: AppDimensions.paddingSupSmall),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Filter(selected_filter: "brands");
              }));
            },
            child: Text(
              'top_brands_ucf'.tr(context: context),
              style: const TextStyle(
                color: Color(0xff000000),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        CustomBrandListWidget(
            homePresenter: homeData, showViewAllButton: showViewAllButton),
      ]),
    );
  }
}
