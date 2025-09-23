import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../dynamic_size_image_banner.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class FlashDealBanner extends StatelessWidget {
  final HomePresenter? homeData;
  final BuildContext? context;

  const FlashDealBanner({Key? key, this.homeData, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Null safety check for homeData
    if (homeData == null) {
      return Container(
        height: 100,
        child: Center(child: Text('no_data_is_available'.tr(context: context))),
      );
    }

    // When data is loading and no images are available
    if (homeData!.isFlashDealInitial && homeData!.banners.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppDimensions.paddingMedium,
            right: AppDimensions.paddingMedium,
            top: 10,
            bottom: 20),
        child: ShimmerHelper().buildBasicShimmer(height: 120),
      );
    }

    // When banner images are available
    else if (homeData!.banners.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 237,
          aspectRatio: 1,
          viewportFraction: .60,
          initialPage: 0,
          padEnds: false,
          enableInfiniteScroll: true,
          autoPlay: true,
          onPageChanged: (index, reason) {
            // Optionally handle page change
          },
        ),
        items: homeData!.banners.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 12, bottom: 10),
                child: FlashBannerWidget(bannerLink: i.banner, slug: i.slug),
              );
            },
          );
        }).toList(),
      );
    }

    // When images are not found and loading is complete
    else if (!homeData!.isFlashDealInitial && homeData!.banners.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            'no_carousel_image_found'.tr(context: context),
            style: const TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    }

    // Default container if no condition matches
    else {
      return const SizedBox(height: 100);
    }
  }
}

class FlashBannerWidget extends StatelessWidget {
  const FlashBannerWidget({
    super.key,
    required this.bannerLink,
    required this.slug,
  });
  final String? bannerLink;
  final String? slug;

  @override
  Widget build(BuildContext context) {
    return DynamicSizeImageBanner(
      urlToOpen: "${AppConfig.RAW_BASE_URL}/flash-deal/$slug",
      photo: bannerLink,
      radius: 10,
    );

    // return Container(
    //   height: size,
    //   width: size,
    //   decoration: BoxDecoration(
    //     color: Colors.white, // background color for container
    //     borderRadius: BorderRadius.circular(AppDimensions.radiusNormal), // rounded corners
    //     boxShadow: [
    //       BoxShadow(
    //         color:
    //             const Color(0xff000000).withValues(alpha: 0.1), // shadow color
    //         spreadRadius: 2, // spread radius
    //         blurRadius: 5, // blur radius
    //         offset: const Offset(0, 3), // changes position of shadow
    //       ),
    //     ],
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(
    //         10), // round corners for the image too
    //     child: InkWell(
    //       onTap: () => GoRouter.of(context).go('/flash-deal/$slug'),
    //       child: AIZImage.radiusImage(bannerLink, 6),
    //       // Display the image with rounded corners
    //     ),
    //   ),
    // );
  }
}
