// import 'package:active_ecommerce_cms_demo_app/custom/box_decorations.dart';
// import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
// import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
// import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
// import 'package:flutter/material.dart';

// class AuthScreen {
//   static Widget buildScreen(
//       BuildContext context, String headerText, Widget child) {
//     return Directionality(
//       textDirection:
//           app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         //key: _scaffoldKey,
//         //drawer: MainDrawer(),
//         backgroundColor: Colors.white,
//         //appBar: buildAppBar(context),

//         body: Stack(
//           children: [
//             Container(
//               height: DeviceInfo(context).height! / 3,
//               width: DeviceInfo(context).width,
//               color: MyTheme.accent_color,
//               alignment: Alignment.topRight,
//               child: Image.asset(
//                 "assets/background_1.png",
//               ),
//             ),
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 10,
//               right: 10,
//               child: IconButton(
//                 icon: Icon(Icons.close, color: MyTheme.white, size: 24),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   print('click');
//                 },
//               ),
//             ),
//             CustomScrollView(
//               //controller: _mainScrollController,
//               physics: const BouncingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics()),
//               slivers: [
//                 SliverList(
//                   delegate: SliverChildListDelegate(
//                     [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 48.0),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 12),
//                               width: 72,
//                               height: 72,
//                               decoration: BoxDecoration(
//                                   color: MyTheme.white,
//                                   borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
//                               child: Image.asset(
//                                   'assets/login_registration_form_logo.png'),
//                             ),
//                           ],
//                           mainAxisAlignment: MainAxisAlignment.center,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 20.0, top: 10),
//                         child: Text(
//                           headerText,
//                           style: TextStyle(
//                               color: MyTheme.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 20),
//                           decoration:
//                               BoxDecorations.buildBoxDecoration_1(radius: 16),
//                           child: child,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/constants/app_images.dart';
import 'package:active_ecommerce_cms_demo_app/custom/box_decorations.dart';
import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:flutter/material.dart';

class AuthScreen {
  static Widget buildScreen(
    BuildContext context,
    String headerText,
    Widget child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: DeviceInfo(context).height! / 3,
            width: DeviceInfo(context).width,
            color: Theme.of(context).primaryColor,
            alignment: AlignmentDirectional.topEnd,
            child: Image.asset(AppImages.backgroundOne),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: MyTheme.white,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSmall,
                              ),
                            ),
                            child: Image.asset(AppImages.loginRegistration),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingLarge,
                        top: AppDimensions.paddingSupSmall,
                      ),
                      child: Text(
                        headerText,
                        style: const TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18.0),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecorations.buildBoxDecoration_1(
                              radius: 16)
                          .copyWith(
                              boxShadow: [const BoxShadow(spreadRadius: 0.08)]),
                      child: child,
                    ),
                  ],
                ),
              )
            ],
          ),
          // Cross Button
          PositionedDirectional(
            top: MediaQuery.paddingOf(context).top + 10,
            end: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
