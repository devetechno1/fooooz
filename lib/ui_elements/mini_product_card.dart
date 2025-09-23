// import 'package:active_ecommerce_cms_demo_app/custom/box_decorations.dart';
// import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
// import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
// import 'package:active_ecommerce_cms_demo_app/screens/product/product_details.dart';
// import 'package:flutter/material.dart';

// import '../helpers/shared_value_helper.dart';

// class MiniProductCard extends StatefulWidget {
//   int? id;
//   String slug;
//   String? image;
//   String? name;
//   String? main_price;
//   String? stroked_price;
//   bool? has_discount;
//   bool? isWholesale;
//   var discount;
//   MiniProductCard({
//     Key? key,
//     this.id,
//     required this.slug,
//     this.image,
//     this.name,
//     this.main_price,
//     this.stroked_price,
//     this.has_discount,
//     this.isWholesale = false,
//     this.discount,
//   }) : super(key: key);

//   @override
//   _MiniProductCardState createState() => _MiniProductCardState();
// }

// class _MiniProductCardState extends State<MiniProductCard> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return ProductDetails(
//             slug: widget.slug,
//           );
//         }));
//       },
//       child: Container(
//         width: 135,
//         decoration: BoxDecorations.buildBoxDecoration_1(),
//         child: Stack(children: [
//           Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 AspectRatio(
//                   aspectRatio: 1,
//                   child: Container(
//                       width: double.infinity,
//                       child: ClipRRect(
//                           borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(AppDimensions.radiusaHalfsmall), bottom: Radius.zero),
//                           child: FadeInImage.assetNetwork(
//                             placeholder: 'AppImages.placeholder',
//                             image: widget.image!,
//                             fit: BoxFit.cover,
//                           ))),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
//                   child: Text(
//                     widget.name!,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     style: TextStyle(
//                         color: MyTheme.font_grey,
//                         fontSize: 12,
//                         height: 1.2,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),
//                 widget.has_discount!
//                     ? Padding(
//                         padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                         child: Text(
//                           SystemConfig.systemCurrency != null
//                               ? widget.stroked_price!.replaceAll(
//                                   SystemConfig.systemCurrency!.code!,
//                                   SystemConfig.systemCurrency!.symbol!)
//                               : widget.stroked_price!,
//                           maxLines: 1,
//                           style: TextStyle(
//                               decoration: TextDecoration.lineThrough,
//                               color: MyTheme.medium_grey,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       )
//                     : Container(),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                   child: Text(
//                     SystemConfig.systemCurrency != null
//                         ? widget.main_price!.replaceAll(
//                             SystemConfig.systemCurrency!.code!,
//                             SystemConfig.systemCurrency!.symbol!)
//                         : widget.main_price!,
//                     maxLines: 1,
//                     style: TextStyle(
//                         color: MyTheme.accent_color,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700),
//                   ),
//                 ),
//               ]),

//           // discount and wholesale
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.topRight,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   if (widget.has_discount!)
//                     Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       margin: EdgeInsets.only(bottom: 5),
//                       decoration: BoxDecoration(
//                         color:Theme.accent_color,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(6.0),
//                           bottomLeft: Radius.circular(6.0),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0x14000000),
//                             offset: Offset(-1, 1),
//                             blurRadius: 1,
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         widget.discount ?? "",
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: const Color(0xffffffff),
//                           fontWeight: FontWeight.w700,
//                           height: 1.8,
//                         ),
//                         textHeightBehavior:
//                             TextHeightBehavior(applyHeightToFirstAscent: false),
//                         softWrap: false,
//                       ),
//                     ),
//                   Visibility(
//                     visible: whole_sale_addon_installed.$,
//                     child: widget.isWholesale!
//                         ? Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.blueGrey,
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(6.0),
//                                 bottomLeft: Radius.circular(6.0),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0x14000000),
//                                   offset: Offset(-1, 1),
//                                   blurRadius: 1,
//                                 ),
//                               ],
//                             ),
//                             child: Text(
//                               "Wholesale",
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: const Color(0xffffffff),
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.8,
//                               ),
//                               textHeightBehavior: TextHeightBehavior(
//                                   applyHeightToFirstAscent: false),
//                               softWrap: false,
//                             ),
//                           )
//                         : SizedBox.shrink(),
//                   )
//                 ],
//               ),
//             ),
//           ),

//           // whole sale
//         ]),
//       ),
//     );
//   }
// }

import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/constants/app_images.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/string_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/screens/product/product_details.dart';
import 'package:flutter/material.dart';

class MiniProductCard extends StatefulWidget {
  final int? id;
  final String slug;
  final String? image;
  final String? name;
  final String? main_price;
  final String? stroked_price;
  final bool? has_discount;
  final bool? isWholesale;
  final TextStyle? priceTextStyle;
  final TextStyle? nameTextStyle;
  final int? rating;
  const MiniProductCard({
    Key? key,
    this.id,
    required this.slug,
    this.image,
    this.name,
    this.main_price,
    this.stroked_price,
    this.has_discount,
    this.isWholesale = false,
    this.priceTextStyle,
    this.nameTextStyle,
    this.rating,
  }) : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            slug: widget.slug,
          );
        }));
      },
      child: SizedBox(
        width: 140,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusNormal),
                        child: FadeInImage.assetNetwork(
                          placeholder: AppImages.placeholder,
                          image: widget.image!,
                          fit: BoxFit.cover,
                        ))),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                  width: double.maxFinite,
                  child: Text(
                    widget.name!,
                    overflow: TextOverflow.ellipsis,
                    textDirection: widget.name!.direction,
                    maxLines: 2,
                    style: widget.nameTextStyle ??
                        const TextStyle(
                            color: MyTheme.font_grey_Light,
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    SystemConfig.systemCurrency != null
                        ? widget.main_price!.replaceAll(
                            SystemConfig.systemCurrency!.code!,
                            SystemConfig.systemCurrency!.symbol!)
                        : widget.main_price!,
                    maxLines: 1,
                    style: widget.priceTextStyle ??
                        TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // RatingBarIndicator(
              //   rating: ratingValue,
              //   itemCount: 5,
              //   itemSize: 18,
              //   itemBuilder: (context, _) =>
              //       const Icon(Icons.star, color: Colors.amber),
              //   unratedColor: Colors.grey,
              //   direction: Axis.horizontal,
              // ),
            ]),
      ),
    );
  }
}
