import 'package:active_ecommerce_cms_demo_app/helpers/string_helper.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_dimensions.dart';
import '../../product/product_details.dart';

class TodaysDealProductsWidget extends StatelessWidget {
  //final List<Product>? products;
  final HomePresenter homePresenter;

  const TodaysDealProductsWidget({
    super.key,
    required this.homePresenter,
  });

  @override
  Widget build(BuildContext context) {
    if (homePresenter.TodayDealList.isEmpty) return const SizedBox();

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: homePresenter.TodayDealList.length,
        itemBuilder: (context, index) {
          final product = homePresenter.TodayDealList[index];

          return GestureDetector(
            onTap: product.slug == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetails(slug: product.slug!),
                      ),
                    );
                  },
            child: Container(
              width: 160,
              margin: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingDefault,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                      child: Image.network(
                        product.thumbnail_image ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name ?? '',
                    maxLines: 2,
                    textDirection: (product.name ?? '').direction,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.main_price ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
