import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:flutter/material.dart';

class HomeSearchBox extends StatelessWidget {
  final BuildContext? context;
  const HomeSearchBox({Key? key, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
        color: const Color(0xffE4E3E8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 63, 63, 63).withValues(alpha: .12),
            blurRadius: 15,
            spreadRadius: 0.4,
            offset: const Offset(0.0, 5.0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.search,
              height: 16,
              color: const Color(0xff7B7980),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              AppConfig.search_bar_text(context),
              style: const TextStyle(fontSize: 13.0, color: Color(0xff7B7980)),
            ),
          ],
        ),
      ),
    );
  }
}
