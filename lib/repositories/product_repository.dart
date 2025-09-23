import 'dart:convert';
import 'dart:developer';

import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/category.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/product_details_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/product_mini_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/variant_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/api-request.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/wholesale_model.dart';

import '../data_model/variant_price_response.dart';

class ProductRepository {
  Future<CatResponse> getCategoryRes() async {
    const String url = ("${AppConfig.BASE_URL}/seller/products/categories");

    final reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return catResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    final String url = ("${AppConfig.BASE_URL}/products/featured?page=$page");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    const String url = ("${AppConfig.BASE_URL}/products/best-seller");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Currency-Code": SystemConfig.systemCurrency?.code ?? "",
      "Currency-Exchange-Rate":
          (SystemConfig.systemCurrency?.exchangeRate).toString(),
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getInHouseProducts({page}) async {
    final String url = ("${AppConfig.BASE_URL}/products/inhouse?page=$page");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    const String url = ("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(id) async {
    final String url = ("${AppConfig.BASE_URL}/flash-deal-products/$id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {String? id = "", name = "", page = 1}) async {
    final String url = ("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=$page&name=$name");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {int? id = 0, name = "", page = 1}) async {
    final String url = ("${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=$page&name=$name");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {required String slug, name = "", page = 1}) async {
    final String url =
        ("${AppConfig.BASE_URL}/products/brand/$slug?page=$page&name=$name");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    final String url = ("${AppConfig.BASE_URL}/products/search" +
        "?page=$page&name=$name&sort_key=$sort_key&brands=$brands&categories=$categories&min=$min&max=$max");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    log("reeeees ${response.body}");
    return productMiniResponseFromJson(response.body);
    
  }

  Future<ProductMiniResponse> getDigitalProducts({
    page = 1,
  }) async {
    final String url = ("${AppConfig.BASE_URL}/products/digital?page=$page");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails({String? slug = ""}) async {
    String? userId;
    if (is_logged_in.$) {
      userId = user_id.$?.toString();
    } else {
      userId = temp_user_id.$;
    }

    if (userId?.trim().isNotEmpty != true) userId = '0';

    final String url =
        ("${AppConfig.BASE_URL}/products/" + slug.toString() + "/$userId");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    if (response.statusCode != 200) {
      throw jsonDecode(response.body)["message"]?.toString() ??
          "some_things_went_wrong".tr();
    }

    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getDigitalProductDetails({int id = 0}) async {
    final String url = ("${AppConfig.BASE_URL}/products/" + id.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFrequentlyBoughProducts(
      {required String slug}) async {
    final String url =
        ("${AppConfig.BASE_URL}/products/frequently-bought/$slug");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {required String slug}) async {
    final String url = ("${AppConfig.BASE_URL}/products/top-from-seller/$slug");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo({
    required String slug,
    String color = '',
    String variants = '',
    int? qty = 1,
  }) async {
    const String url = ("${AppConfig.BASE_URL}/products/variant/price");

    final postBody = jsonEncode({
      'slug': slug,
      "color": color,
      "variants": variants,
      "quantity": qty,
      if (AppConfig.businessSettingsData.guestCheckoutStatus && !is_logged_in.$)
        "temp_user_id": temp_user_id.$
      else
        "user_id": user_id.$,
    });

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Content-Type": "application/json",
        },
        body: postBody);

    return variantResponseFromJson(response.body);
  }

  Future<VariantPriceResponse> getVariantPrice({id, quantity}) async {
    const String url = ("${AppConfig.BASE_URL}/varient-price");

    final postBody = jsonEncode({"id": id, "quantity": quantity});

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Content-Type": "application/json",
        },
        body: postBody);

    return variantPriceResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> lastViewProduct() async {
    const String url = ("${AppConfig.BASE_URL}/products/last-viewed");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    });

    return productMiniResponseFromJson(response.body);
  }

  Future<WholesaleProductModel> getWholesaleProducts(int page) async {
    final String url =
        "${AppConfig.BASE_URL}/wholesale/all-products?page=$page";
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    if (response.statusCode == 200) {
      return WholesaleProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load products");
    }
  }
}
