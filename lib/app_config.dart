import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data_model/business_settings/business_settings.dart';
import 'data_model/business_settings/update_model.dart';
import 'screens/splash_screen/splash_screen_config.dart';
export 'constants/app_dimensions.dart';
export 'constants/app_images.dart';

// final String this_year = DateTime.now().year.toString();

class AppConfig {
  /// To know the device operating system (ios, huawei or any android device)
  static StoreType storeType = StoreType.unknown;

  ///Specifies the splash screen type to use a custom animated widget instead of a static image or traditional screen.
  static SplashScreenType get splashType =>
      SplashScreenType.splashAnimatedImageWidget;

  /// To make force update to app
  static String version = '1.0.0';

  /// App Version (AV) shown on the splash screen.
  /// Used to verify the app build matches the master version.
  static const String mobileVersion = '9.10.45';

  /// Backend Version (BV) used for compatibility checks.
  /// Used to verify the app is compatible with backend data.
  static const String backendVersion = '9.8.1';

  //configure this
  // static String copyright_text =
  //     "@ Deve Finance " + this_year; //this shows in the splash screen
  static const String app_name_ar = "FOOOOZ";
  static const String app_name_en = "FOOOOZ";

  /// This get the name of the application in deviceLocale
  static String appNameOnDeviceLang =
      PlatformDispatcher.instance.locale.languageCode == 'ar'
          ? app_name_ar
          : app_name_en;

  static bool isDebugMode = kDebugMode;
  static bool turnDevicePreviewOn = isDebugMode;

  static String search_bar_text(BuildContext context) {
    return 'search_in_app_name'.tr(
      context: context,
      args: {'app_name': 'app_name'.tr(context: context)},
    );
  }

  static String purchase_code =
      "a"; //enter your purchase code for the app from codecanyon
  static String system_key =
      r"a"; //enter your purchase code for the app from codecanyon

  //Default language config
  static String default_language =
      CustomLocalization.supportedLocales.first.languageCode;
  static String mobile_app_code =
      CustomLocalization.supportedLocales.first.languageCode;
  static bool app_language_rtl = mobile_app_code == "ar";

  //Default country config
  static String default_country = "EG";

  //configure this
  static const bool HTTPS =
      true; //if you are using localhost , set this to false
  static const DOMAIN_PATH =
      "fooooz.com"; //use only domain name without http:// or https://

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  // static const String RAW_BASE_URL = "http://192.168.1.200/fooooz";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";

  static const LatLng initPlace = LatLng(30.723003387451172, 31.02609634399414);

  // static HomePageType selectedHomePageType = HomePageType.home;
  static BusinessSettingsData businessSettingsData = BusinessSettingsData();

  static Map<String, dynamic> deviceInfo = {};
}
