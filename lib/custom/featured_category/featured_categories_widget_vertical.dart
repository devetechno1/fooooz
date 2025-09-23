import 'package:flutter/material.dart';

import '../../constants/app_dimensions.dart';
import '../../constants/app_images.dart';
import '../../helpers/shimmer_helper.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../screens/category_list_n_product/category_products.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class FeatureCategoriesWidgetVertical extends StatelessWidget {
  final HomePresenter homeData;
  final int crossAxisCount;
  const FeatureCategoriesWidgetVertical(
      {super.key, required this.homeData, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    if (homeData.isCategoryInitial && homeData.featuredCategoryList.isEmpty) {
      // Handle shimmer loading here (if no categories loaded yet)
      return ShimmerHelper().buildGridShimmerWithAxisCount(
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          item_count: 10,
          mainAxisExtent: 170.0,
          controller: homeData.featuredCategoryScrollController);
    } else if (homeData.featuredCategoryList.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
            left: AppDimensions.paddingLarge,
            right: AppDimensions.paddingLarge,
            top: 11,
            bottom: 24),
        scrollDirection: Axis.vertical,
        controller: homeData.featuredCategoryScrollController,
        itemCount: homeData.featuredCategoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1, // Ensures square boxes
            crossAxisSpacing: 12,
            mainAxisSpacing: 3,
            mainAxisExtent: 150.0),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoryProducts(
                        name: homeData.featuredCategoryList[index].name ?? '',
                        slug: homeData.featuredCategoryList[index].slug ?? '',
                      );
                    },
                  ),
                );
              },
              child: Container(
                child: Column(
                  children: [
                    AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff000000)
                                    .withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusNormal),
                            child: FadeInImage.assetNetwork(
                              placeholder: AppImages.placeholder,
                              image: homeData
                                      .featuredCategoryList[index].coverImage ??
                                  '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        homeData.featuredCategoryList[index].name ?? '',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      );
    } else if (!homeData.isCategoryInitial &&
        homeData.featuredCategoryList.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            'no_category_found'.tr(context: context),
            style: const TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    } else {
      return Container(
        height: 100,
      );
    }
  }
}
