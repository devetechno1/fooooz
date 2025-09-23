import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/flash%20deals%20banner/flash_deal_banner.dart';

import 'package:active_ecommerce_cms_demo_app/helpers/context_ex.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/home.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/time_circular_container.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/time_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({super.key, required this.isCircle, this.backgroundColor});
  final bool isCircle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: homeData,
        builder: (context, child) {
          if (homeData.flashDeal == null) return const SizedBox();
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FlashDealList();
                  }));
                },
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Text('flash_sale'.tr(context: context),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Image.asset(AppImages.flashDeal,
                          height: 20, color: MyTheme.golden),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                    width: context.isPhoneWidth ? double.maxFinite : 350,
                    padding:
                        const EdgeInsets.all(AppDimensions.paddingSmallExtra),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: backgroundColor ??
                          AppConfig.businessSettingsData.flashDealBgColor ??
                          const Color(0xFFF9F8F8),
                      borderRadius: context.isPhoneWidth
                          ? null
                          : BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        // any of them > 0 then show timer : sizedBox
                        (homeData.flashDealRemainingTime.days > 0 ||
                                homeData.flashDealRemainingTime.hours > 0 ||
                                homeData.flashDealRemainingTime.min > 0 ||
                                homeData.flashDealRemainingTime.sec > 0)
                            ? buildTimerRow(homeData.flashDealRemainingTime)
                            : const SizedBox.shrink(),
                        const SizedBox(height: 15),
                        FlashBannerWidget(
                          bannerLink: homeData.flashDeal?.banner,
                          slug: homeData.flashDeal!.slug,
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 30),
            ],
          );
        });
  }

  String timeText(String val, {int default_length = 2}) {
    return val.padLeft(default_length, '0');
  }

  Widget buildTimerRow(CurrentRemainingTime time) {
    return Builder(
      builder: (context) {
        if (isCircle) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // const Spacer(),
                //const SizedBox(width: 20,),
                Row(
                  children: [
                    TimeCircularContainer(
                      currentValue: time.days,
                      totalValue: 365,
                      timeText: timeText(
                        (time.days).toString(),
                        default_length: 2,
                      ),
                      timeType: 'days'.tr(context: context),
                    ),
                    const SizedBox(width: 10),
                    TimeCircularContainer(
                      currentValue: time.hours,
                      totalValue: 24,
                      timeText: timeText(
                        (time.hours).toString(),
                        default_length: 2,
                      ),
                      timeType: 'hours'.tr(context: context),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TimeCircularContainer(
                      currentValue: time.min,
                      totalValue: 60,
                      timeText: timeText(
                        (time.min).toString(),
                        default_length: 2,
                      ),
                      timeType: 'minutes'.tr(context: context),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    TimeCircularContainer(
                      currentValue: time.sec,
                      totalValue: 60,
                      timeText: timeText(
                        (time.sec).toString(),
                        default_length: 2,
                      ),
                      timeType: 'seconds'.tr(context: context),
                    ),
                  ],
                ),
                Flexible(
                  child: Builder(builder: (context) {
                    final Color textColor =
                        AppConfig.businessSettingsData.isLightFlashDealTextColor
                            ? Colors.white
                            : Colors.black;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FlashDealList();
                              }));
                            },
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: 'shop_more_ucf'
                                            .tr(context: context)),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 4.0),
                                        child: Icon(
                                          Icons.arrow_forward_outlined,
                                          size: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                )

                //   Flexible(
                //     flex: 2,
                //   child: Row(
                //    // mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Flexible(
                //         flex: 2,
                //         child: Text(
                //           'shop_more_ucf'.tr(context: context),
                //           //overflow: TextOverflow.clip, // عشان لو كبر الكلام
                //           style: const TextStyle(
                //             fontSize: 10,
                //             color: Color.fromARGB(255, 68, 71, 73),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 3),
                //       const Icon(
                //         Icons.arrow_forward_outlined,
                //         size: 10,
                //         color: Color.fromARGB(255, 68, 71, 73),
                //       ),
                //       const SizedBox(width: 10),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        }
        return Container(
          height: 35,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmallExtra),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                RowTimeDataWidget(
                  time: "${time.days}",
                  timeType: 'days'.tr(context: context),
                  isFirst: true,
                ),
                RowTimeDataWidget(
                  time: "${time.hours}",
                  timeType: 'hours'.tr(context: context),
                ),
                RowTimeDataWidget(
                  time: "${time.min}",
                  timeType: 'minutes'.tr(context: context),
                ),
                RowTimeDataWidget(
                  time: "${time.sec}",
                  timeType: 'seconds'.tr(context: context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
