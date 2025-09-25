// To parse this JSON VariantData, do
//
//     final variantResponse = variantResponseFromJson(jsonString);

import 'dart:convert';

import 'variant_price_response.dart';

VariantResponse variantResponseFromJson(String str) =>
    VariantResponse.fromJson(json.decode(str));

String variantResponseToJson(VariantResponse VariantData) =>
    json.encode(VariantData.toJson());

class VariantResponse {
  bool? result;
  VariantData? variantData;

  VariantResponse({
    this.result,
    this.variantData,
  });

  factory VariantResponse.fromJson(Map<String, dynamic> json) =>
      VariantResponse(
        result: json["result"],
        variantData: VariantData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": variantData!.toJson(),
      };
}

class VariantData {
  String? price;
  double basePrice;
  int? stock;
  int? inCart;
  String? stockTxt;
  List<int>? foooozNumber;
  bool digital;
  String? variant;
  String? variation;
  int? maxLimit;
  int? inStock;
  String? image;

  VariantData({
    this.price,
    this.basePrice = 0.0,
    this.stock,
    this.inCart,
    this.stockTxt,
    this.foooozNumber,
    this.digital = false,
    this.variant,
    this.variation,
    this.maxLimit,
    this.inStock,
    this.image,
  });

  factory VariantData.fromJson(Map<String, dynamic> json) => VariantData(
        price: json["price"],
        basePrice: double.tryParse(json["base_price"].toString()) ?? 0,
        stock: int.parse(json["stock"].toString()),
        inCart: int.tryParse(json["in_cart"].toString()),
        stockTxt: "${json["stock_txt"]}",
        digital: "${json["digital"]}" == '1',
        foooozNumber: getFoooozNumber(json["fooooz_number"]),
        variant: json["variant"],
        variation: json["variation"],
        maxLimit: int.parse(json["max_limit"].toString()),
        inStock: int.parse(json["in_stock"].toString()),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "base_price": basePrice,
        "stock": stock,
        "in_cart": inCart,
        "digital": digital,
        if (foooozNumber != null) "fooooz_number": foooozNumber!.join("-"),
        "variant": variant,
        "variation": variation,
        "max_limit": maxLimit,
        "in_stock": inStock,
        "image": image,
      };
}
