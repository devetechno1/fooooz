import 'package:flutter/material.dart';

import '../presenter/home_presenter.dart';
import 'home_banners/home_banners_list.dart';

class HomeCarouselSlider extends StatelessWidget {
  final HomePresenter? homeData;
  const HomeCarouselSlider({super.key, this.homeData});

  @override
  Widget build(BuildContext context) {
    return HomeBannersList(
      isBannersInitial: homeData!.isCarouselInitial,
      bannersImagesList: homeData!.carouselImageList,
      aspectRatio: 338 / 140,
      viewportFraction: 1,
    );
  }
}
