// import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
// import 'package:active_ecommerce_cms_demo_app/data_model/cart_response.dart';
// import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
// import 'package:active_ecommerce_cms_demo_app/presenter/cart_counter.dart';
// import 'package:active_ecommerce_cms_demo_app/repositories/cart_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';

// import '../custom/aiz_route.dart';
// import '../helpers/shared_value_helper.dart';
// import '../screens/checkout/select_address.dart';
// import '../screens/guest_checkout_pages/guest_checkout_address.dart';

// class CartProvider extends ChangeNotifier {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   ScrollController _mainScrollController = ScrollController();
//   List _shopList = [];
//   CartResponse? _shopResponse;
//   bool _isInitial = true;
//   double _cartTotal = 0.00;
//   String _cartTotalString = ". . .";

//   GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
//   ScrollController get mainScrollController => _mainScrollController;
//   List get shopList => _shopList;
//   CartResponse? get shopResponse => _shopResponse;
//   bool get isInitial => _isInitial;
//   double get cartTotal => _cartTotal;
//   String get cartTotalString => _cartTotalString;

//   void initState(BuildContext context) {
//     fetchData(context);
//   }

//   void dispose() {
//     _mainScrollController.dispose();
//   }

//   Future<void> fetchData(BuildContext context) async {
//     getCartCount(context);
//     CartResponse cartResponseList =
//         await CartRepository().getCartResponseList(user_id.$);

//     if (cartResponseList.data != null && cartResponseList.data!.length > 0) {
//       _shopList = cartResponseList.data!;
//       _shopResponse = cartResponseList;

//       // Recalculate totals with the updated response
//       getSetCartTotal();
//     }
//     _isInitial = false;

//     notifyListeners();
//   }

//   void getCartCount(BuildContext context) {
//     Provider.of<CartCounter>(context, listen: false).getCount();
//   }

//   void getSetCartTotal() {
//     double total = 0.0;

//     // Iterate through the _shopList to calculate the total
//     for (var shop in _shopList) {
//       if (shop.cartItems != null) {
//         for (var item in shop.cartItems) {
//           // Ensure price and quantity are numeric
//           double price = double.tryParse(item.price.toString()) ?? 0.0;
//           int quantity = int.tryParse(item.quantity.toString()) ?? 0;

//           total += price * quantity;
//         }
//       }
//     }

//     _cartTotal = total;

//     // Format the total as a string using the system's currency
//     _cartTotalString = "${SystemConfig.systemCurrency!.symbol}$total";

//     notifyListeners();
//   }

//   void onQuantityIncrease(
//       BuildContext context, int sellerIndex, int itemIndex) {
//     if (_shopList[sellerIndex].cartItems[itemIndex].quantity <
//         _shopList[sellerIndex].cartItems[itemIndex].upperLimit) {
//       _shopList[sellerIndex].cartItems[itemIndex].quantity++;
//       notifyListeners();
//       process(context, mode: "update");
//     } else {
//       ToastComponent.showDialog(
//           "${'cannot_order_more_than'.tr(context: context)} ${_shopList[sellerIndex].cartItems[itemIndex].upperLimit} ${'items_of_this_all_lower'.tr(context: context)}",
//           gravity: ToastGravity.CENTER,
//           duration: Toast.LENGTH_LONG);
//     }
//   }

//   void onQuantityDecrease(
//       BuildContext context, int sellerIndex, int itemIndex) {
//     if (_shopList[sellerIndex].cartItems[itemIndex].quantity >
//         _shopList[sellerIndex].cartItems[itemIndex].lowerLimit) {
//       _shopList[sellerIndex].cartItems[itemIndex].quantity--;
//       notifyListeners();
//       process(context, mode: "update");
//     } else {
//       ToastComponent.showDialog(
//         "${'cannot_order_more_than'.tr(context: context)} ${_shopList[sellerIndex].cartItems[itemIndex].lowerLimit} ${'items_of_this_all_lower'.tr(context: context)}",
//       );
//     }
//   }

//   Future<void> onPressDelete(BuildContext context, String cartId) async {
//     final confirmed = await _confirmDelete(context);
//     if (!confirmed) return;

//     try {
//       final response =
//           await CartRepository().getCartDeleteResponse(int.parse(cartId));

//       if (response.result == true) {
//         // Remove the item from _shopList
//         for (var shop in _shopList) {
//           if (shop.cartItems != null) {
//             shop.cartItems.removeWhere((item) => item.id.toString() == cartId);
//           }
//         }

//         // Recalculate totals after removing the item
//         getSetCartTotal();

//         // Notify listeners to update the UI
//         notifyListeners();

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Item removed successfully")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to remove item: ${response.message}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }

//   Future<bool> _confirmDelete(BuildContext context) async {
//     return await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text("Confirm Delete"),
//             content: Text("Are you sure you want to delete this item?"),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(contextfalse),
//                 child: Text("Cancel"),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(contexttrue),
//                 child: Text("Delete"),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   void onPressUpdate(BuildContext context) {
//     process(context, mode: "update");
//   }

//   void onPressProceedToShipping(BuildContext context) {
//     process(context, mode: "proceed_to_shipping");
//   }

//   void process(BuildContext context, {required String mode}) async {
//     var cartIds = [];
//     var cartQuantities = [];
//     if (_shopList.length > 0) {
//       _shopList.forEach((shop) {
//         if (shop.cartItems.length > 0) {
//           shop.cartItems.forEach((cartItem) {
//             cartIds.add(cartItem.id);
//             cartQuantities.add(cartItem.quantity);
//           });
//         }
//       });
//     }

//     if (cartIds.length == 0) {
//       ToastComponent.showDialog(
//         'cart_is_empty'.tr(context: context),
//       );
//       return;
//     }

//     var cartIdsString = cartIds.join(',').toString();
//     var cartQuantitiesString = cartQuantities.join(',').toString();

//     var cartProcessResponse = await CartRepository()
//         .getCartProcessResponse(cartIdsString, cartQuantitiesString);

//     if (cartProcessResponse.result == false) {
//       ToastComponent.showDialog(
//         cartProcessResponse.message,
//       );
//     } else {
//       if (mode == "update") {
//         fetchData(context);
//       } else if (mode == "proceed_to_shipping") {
//         if (AppConfig.businessSettingsData.guestCheckoutStatus && !is_logged_in.$) {
//           // Handle guest checkout logic
//           // For example, navigate to guest checkout page
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return GuestCheckoutAddress();
//           }));
//         } else {
//           // Navigate to select address page
//           // Example:
//           AIZRoute.push(context, SelectAddress()).then((value) {
//             onPopped(context, value);
//           });
//         }
//       }
//     }
//   }

//   Future<void> reset() async {
//     _shopList.clear();
//     _isInitial = true;
//     _cartTotal = 0.00;
//     _cartTotalString = ". . .";
//     notifyListeners();
//   }

//   Future<void> onRefresh(BuildContext context) async {
//     reset();
//     fetchData(context);
//   }

//   void onPopped(BuildContext context, dynamic value) {
//     reset();
//     fetchData(context);
//   }
// }

import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/cart_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/cart_counter.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';
import '../custom/aiz_route.dart';
import '../custom/btn.dart';
import '../helpers/debouncer.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';
import '../repositories/address_repository.dart';
import '../screens/checkout/select_address.dart';
import '../screens/checkout/shipping_info.dart';
import '../screens/guest_checkout_pages/guest_checkout_address.dart';
import '../screens/home/home.dart';

ValueNotifier<double> cartTotalAmount = ValueNotifier<double>(0.0);
ValueNotifier<int> cartQuantityProduct = ValueNotifier<int>(0);

class CartProvider extends ChangeNotifier {
  final ScrollController _mainScrollController = ScrollController();
  List<Datum> _shopList = [];
  CartResponse? _shopResponse;
  bool _isInitial = true;
  double _cartTotal = 0.00;
  String _cartTotalString = ". . .";

  ScrollController get mainScrollController => _mainScrollController;
  List<Datum> get shopList => _shopList;
  CartResponse? get shopResponse => _shopResponse;
  bool get isInitial => _isInitial;
  bool get isFreeShipping =>
      // false;
      _cartTotal >
          AppConfig.businessSettingsData.freeShippingMinimumOrderAmount &&
      AppConfig.businessSettingsData.freeShippingMinimumCheck;
  double get cartTotal => _cartTotal;
  String get cartTotalString => _cartTotalString;

  Debouncer debouncer = Debouncer(milliseconds: 900);

  int get itemsCount {
    int count = 0;
    for (var e in _shopList) {
      count += (e.cartItems?.length ?? 0);
    }
    return count;
  }

  bool get isMinOrderQuantityNotEnough =>
      shopList.isNotEmpty && minOrderQuantityNotEnough(itemsCount);
  bool get isMinOrderAmountNotEnough =>
      shopList.isNotEmpty && minOrderAmountNotEnough(_cartTotal);

  void initState(BuildContext context) {
    fetchData(context);
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    debouncer.cancel();
    super.dispose();
  }

  Future<void> fetchData(BuildContext context) async {
    getCartCount(context);
    final CartResponse cartResponseList =
        await CartRepository().getCartResponseList();

    if (cartResponseList.data != null) {
      _shopList = cartResponseList.data!;
      _shopResponse = cartResponseList;
      getSetCartTotal();
    }
    _isInitial = false;

    notifyListeners();
  }

  Future<void> getCartCount(BuildContext context) {
    return Provider.of<CartCounter>(context, listen: false).getCount();
  }

  void getSetCartTotal() {
    _cartTotalString = _shopResponse!.grandTotal!.replaceAll(
        SystemConfig.systemCurrency?.code ?? '',
        SystemConfig.systemCurrency?.symbol ?? '');
    _cartTotal = double.tryParse(_cartTotalString
            .replaceAll(",", '')
            .replaceAll("${SystemConfig.systemCurrency?.symbol}", '')
            .replaceAll("${SystemConfig.systemCurrency?.code}", '')) ??
        0;

    notifyListeners();
  }

  Future<void> onQuantityIncrease(
      BuildContext context, int sellerIndex, int itemIndex) async {
    if (_shopList[sellerIndex].cartItems![itemIndex].quantity <
        _shopList[sellerIndex].cartItems![itemIndex].maxQuantity) {
      _shopList[sellerIndex].cartItems![itemIndex].quantity =
          _shopList[sellerIndex].cartItems![itemIndex].quantity + 1;
      _shopList[sellerIndex].cartItems![itemIndex].isLoading = true;
      notifyListeners();
      debouncer(
        () async {
          final bool hasError = await process(context, mode: "update");
          _shopList[sellerIndex].cartItems![itemIndex].isLoading = false;
          if (hasError) {
            _shopList[sellerIndex].cartItems![itemIndex].quantity =
                _shopList[sellerIndex].cartItems![itemIndex].quantity - 1;
            notifyListeners();
          }
          cartTotalAmount.value = cartTotal;
          debouncer.cancel();
        },
      );
    } else {
      ToastComponent.showDialog(
        "${'maxOrderQuantityLimit'.tr(
          context: context,
          args: {
            "maxQuantity":
                "${_shopList[sellerIndex].cartItems![itemIndex].maxQuantity}"
          },
        )}",
        isError: true,
      );
    }
  }

  Future<void> onQuantityDecrease(
      BuildContext context, int sellerIndex, int itemIndex) async {
    if (_shopList[sellerIndex].cartItems![itemIndex].quantity >
        _shopList[sellerIndex].cartItems![itemIndex].lowerLimit!) {
      _shopList[sellerIndex].cartItems![itemIndex].quantity =
          _shopList[sellerIndex].cartItems![itemIndex].quantity - 1;
      _shopList[sellerIndex].cartItems![itemIndex].isLoading = true;
      notifyListeners();
      debouncer(
        () async {
          final bool hasError = await process(context, mode: "update");
          if (hasError) {
            _shopList[sellerIndex].cartItems![itemIndex].quantity =
                _shopList[sellerIndex].cartItems![itemIndex].quantity + 1;
            notifyListeners();
          }
          _shopList[sellerIndex].cartItems![itemIndex].isLoading = false;
          cartTotalAmount.value = cartTotal;
          debouncer.cancel();
        },
      );
    } else {
      ToastComponent.showDialog(
        "${'minimumOrderQuantity'.tr(
          context: context,
          args: {
            "minQuantity":
                "${_shopList[sellerIndex].cartItems![itemIndex].minQuantity}"
          },
        )}",
        isError: true,
      );
    }
  }

  void onPressDelete(
      BuildContext context, String cartId, int sellerIndex, int itemIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.only(
            top: 30.0, left: 2.0, right: 2.0, bottom: 20.0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            'are_you_sure_to_remove_this_item'.tr(context: context),
            maxLines: 3,
            style: const TextStyle(color: MyTheme.font_grey, fontSize: 14),
          ),
        ),
        actions: [
          Btn.basic(
            child: Text(
              'cancel_ucf'.tr(context: context),
              style: const TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              notifyListeners();
            },
          ),
          Btn.basic(
            color: MyTheme.soft_accent_color,
            child: Text(
              'confirm_ucf'.tr(context: context),
              style: const TextStyle(color: MyTheme.dark_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              confirmDelete(context, cartId, sellerIndex, itemIndex);
            },
          ),
        ],
      ),
    );
  }

  Future<void> confirmDelete(BuildContext context, String cartId,
      int sellerIndex, int itemIndex) async {
    _shopList[sellerIndex].cartItems![itemIndex].isLoading = true;
    notifyListeners();
    final cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(int.parse(cartId));

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(
        color: Colors.green,
        // Theme.of(context).colorScheme.error,
        cartDeleteResponse.message,
      );

      reset();
      fetchData(context);
    } else {
      ToastComponent.showDialog(
        cartDeleteResponse.message,
      );
    }
    // _shopList[sellerIndex].cartItems![itemIndex].isLoading = false;
    notifyListeners();
  }

  void onPressUpdate(BuildContext context) {
    process(context, mode: "update");
  }

  void onPressProceedToShipping(BuildContext context) {
    for (Datum shop in _shopList) {
      for (CartItem cartItem in shop.cartItems ?? []) {
        if (cartItem.quantity < cartItem.minQuantity) {
          ToastComponent.showDialog(
            'productBelowMinQuantity'.tr(context: context),
            isError: true,
          );
          return;
        } else if (cartItem.quantity > cartItem.maxQuantity) {
          ToastComponent.showDialog(
            'productExceedsMaxQuantity'.tr(context: context),
            isError: true,
          );
          return;
        }
      }
    }
    process(context, mode: "proceed_to_shipping");
  }

  Future<bool> process(BuildContext context, {required String mode}) async {
    final cartIds = [];
    final cartQuantities = [];
    if (_shopList.isNotEmpty) {
      _shopList.forEach((shop) {
        if (shop.cartItems!.isNotEmpty) {
          shop.cartItems!.forEach((cartItem) {
            cartIds.add(cartItem.id);
            int _quantity = cartItem.quantity;

            if (_quantity > cartItem.maxQuantity) {
              _quantity = cartItem.maxQuantity;
            } else if (_quantity < cartItem.minQuantity) {
              _quantity = cartItem.minQuantity;
            }
            cartQuantities.add(_quantity);
          });
        }
      });
    }

    if (cartIds.isEmpty) {
      ToastComponent.showDialog('cart_is_empty'.tr(context: context));
      return true;
    }

    final cartIdsString = cartIds.join(',').toString();
    final cartQuantitiesString = cartQuantities.join(',').toString();

    final cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cartIdsString, cartQuantitiesString);
    if (homeData.defaultAddress?.id != null)
      await AddressRepository().getAddressUpdateInCartResponse(
          address_id: homeData.defaultAddress?.id);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message, isError: true);
      return true;
    } else {
      if (mode == "update") {
        fetchData(context);
      } else if (mode == "proceed_to_shipping") {
        if (isMinOrderQuantityNotEnough) {
          ToastComponent.showDialog(
              '${'minimum_order_qty_is'.tr(context: context)} ${AppConfig.businessSettingsData.minimumOrderQuantity}',
              color: Theme.of(context).colorScheme.error);
          return true;
        } else if (isMinOrderAmountNotEnough) {
          ToastComponent.showDialog(
              '${'minimum_order_amount_is'.tr(context: context)} ${AppConfig.businessSettingsData.minimumOrderAmount}',
              color: Theme.of(context).colorScheme.error);
          return true;
        }
        if (AppConfig.businessSettingsData.guestCheckoutStatus &&
            !is_logged_in.$) {
          // Handle guest checkout logic
          // For example, navigate to guest checkout page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const GuestCheckoutAddress();
          }));
        } else {
          // Navigate to select address page
          // Example:
          Future.delayed(
            Duration.zero,
            () {
              AIZRoute.push(
                context,
                AppConfig.businessSettingsData.sellerWiseShipping
                    ? const ShippingInfo()
                    : const SelectAddress(),
                SystemConfig.systemUser?.phone,
                null,
                SystemConfig.systemUser?.phone != null,
              ).then((value) {
                onPopped(context, value);
              });
            },
          );
        }
      }
      return false;
    }
  }

  void reset() {
    _shopList.clear();
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";
    notifyListeners();
  }

  Future<void> onRefresh(BuildContext context) async {
    reset();
    await fetchData(context);
  }

  void onPopped(BuildContext context, dynamic value) {
    reset();
    fetchData(context);
  }
}
