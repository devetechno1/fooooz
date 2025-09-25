import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/num_ex.dart';
import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:flutter/material.dart';

import '../data_model/cart_response.dart';
import '../data_model/product_details_response.dart';
import '../helpers/system_config.dart';
import '../my_theme.dart';
import '../presenter/cart_provider.dart';
import '../screens/product/product_details.dart';
import 'box_decorations.dart';
import 'device_info.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

import 'wholesale_text_widget.dart';

class CartSellerItemCardWidget extends StatelessWidget {
  final int sellerIndex;
  final int itemIndex;
  final CartProvider cartProvider;
  final int index;

  const CartSellerItemCardWidget(
      {Key? key,
      required this.cartProvider,
      required this.sellerIndex,
      required this.itemIndex,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartItem item =
        cartProvider.shopList[sellerIndex].cartItems![itemIndex];
    final bool hasWholesale = makeNewVisualWholesale(item.wholesales);
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusHalfSmall)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: DeviceInfo(context).width! / 4,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadiusDirectional.horizontal(
                      start: Radius.circular(AppDimensions.radiusHalfSmall),
                      end: Radius.zero,
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: AppImages.placeholder,
                      image: item.productThumbnailImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (item.isNotAvailable)
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: const BorderRadiusDirectional.horizontal(
                          start: Radius.circular(
                            AppDimensions.radiusHalfSmall,
                          ),
                          end: Radius.zero,
                        ),
                      ),
                      child: Text(
                        'notAvailable'.tr(context: context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.productName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    if (item.foooozNumber?.isNotEmpty == true)
                      Text(
                        'fooooz_number_cart'.tr(
                          context: context,
                          args: {'fooooz_number': "${item.foooozNumber}"},
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    AnimatedNumberText<double>(
                      double.tryParse(
                            item.price!.replaceAll(RegExp('[^0-9.]'), ''),
                          ) ??
                          0.0,
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      formatter: (value) {
                        return '${value.withSeparator} ${SystemConfig.systemCurrency?.symbol ?? ''}'
                            .trim();
                      },
                    ),
                    if (hasWholesale)
                      WholesaleAddedData(
                        itemIndex: itemIndex,
                        sellerIndex: sellerIndex,
                        auctionProduct: item.auctionProduct,
                        wholesales: item.wholesales,
                        cartProvider: cartProvider,
                      ),
                    Builder(
                      builder: (context) {
                        String? text;
                        if (item.quantity < item.minQuantity) {
                          text = 'minimumOrderQuantity'.tr(
                              context: context,
                              args: {"minQuantity": "${item.minQuantity}"});
                        } else if (item.quantity > item.maxQuantity) {
                          text = 'maxOrderQuantityLimit'.tr(
                              context: context,
                              args: {"maxQuantity": "${item.maxQuantity}"});
                        }
                        if (text == null) return const SizedBox();
                        return Center(
                          child: Text(
                            text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Visibility(
                  visible: item.isLoading,
                  child: const Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingSmall),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

                const Spacer(),
                ////////////////////////////////////////////////
                Padding(
                  padding: hasWholesale || item.isDigital
                      ? const EdgeInsets.only(
                          bottom: AppDimensions.paddingNormal,
                          left: AppDimensions.paddingNormal,
                          right: AppDimensions.paddingNormal,
                        )
                      : const EdgeInsets.only(
                          bottom: AppDimensions.paddingNormal,
                        ),
                  child: GestureDetector(
                    onTap: () async {
                      cartProvider.onPressDelete(
                        context,
                        item.id.toString(),
                        sellerIndex,
                        itemIndex,
                      );
                    },
                    child: Image.asset(
                      AppImages.trash,
                      height: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            if (!hasWholesale && !item.isDigital)
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingDefault),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _AddRemoveItemFromCart(
                      icon: Icons.add,
                      auctionProduct: item.auctionProduct,
                      onTap: () {
                        if (item.auctionProduct == 0) {
                          cartProvider.onQuantityIncrease(
                            context,
                            sellerIndex,
                            itemIndex,
                          );
                        }
                        return;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.paddingSmall,
                        bottom: AppDimensions.paddingSmall,
                      ),
                      child: Text(
                        "${int.tryParse(item.quantity.toString()) ?? 0}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _AddRemoveItemFromCart(
                      icon: Icons.remove,
                      auctionProduct: item.auctionProduct,
                      onTap: () {
                        if (item.auctionProduct == 0) {
                          cartProvider.onQuantityDecrease(
                            context,
                            sellerIndex,
                            itemIndex,
                          );
                        }
                        return;
                      },
                    ),
                  ],
                ),
              )
          ]),
    );
  }
}

class _AddRemoveItemFromCart extends StatelessWidget {
  final IconData icon;
  final int? auctionProduct;
  final void Function()? onTap;

  const _AddRemoveItemFromCart({
    required this.icon,
    this.auctionProduct,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecorations.buildCartCircularButtonDecoration(),
        child: Icon(
          icon,
          color: auctionProduct == 0
              ? Theme.of(context).primaryColor
              : MyTheme.grey_153,
          size: 12,
        ),
      ),
    );
  }
}

class WholesaleAddedData extends StatelessWidget {
  const WholesaleAddedData({
    super.key,
    required this.wholesales,
    required this.cartProvider,
    required this.sellerIndex,
    required this.itemIndex,
    required this.auctionProduct,
  });

  final List<Wholesale> wholesales;
  final CartProvider cartProvider;
  final int sellerIndex;
  final int itemIndex;
  final int? auctionProduct;

  @override
  Widget build(BuildContext context) {
    final CartItem item =
        cartProvider.shopList[sellerIndex].cartItems![itemIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: AppDimensions.paddingSmall,
        children: [
          _AddRemoveItemFromCart(
            icon: Icons.add,
            auctionProduct: auctionProduct,
            onTap: () {
              if (auctionProduct == 0) {
                cartProvider.onQuantityIncrease(
                  context,
                  sellerIndex,
                  itemIndex,
                );
              }
              return;
            },
          ),
          Expanded(
            child: WholesaleTextWidget(
              wholesales: wholesales,
              quantity: item.quantity,
            ),
          ),
          _AddRemoveItemFromCart(
            icon: Icons.remove,
            auctionProduct: auctionProduct,
            onTap: () {
              if (auctionProduct == 0) {
                cartProvider.onQuantityDecrease(
                  context,
                  sellerIndex,
                  itemIndex,
                );
              }
              return;
            },
          ),
        ],
      ),
    );
  }
}
