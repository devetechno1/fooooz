import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/home_search_box.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:flutter/material.dart';

import '../../../helpers/shared_value_helper.dart';
import '../home.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BuildAppBar({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) => appBar;

  @override
  Size get preferredSize => appBar.preferredSize;

  AppBar get appBar => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        elevation: 0,
        bottom:
            is_logged_in.$ && AppConfig.businessSettingsData.sellerWiseShipping
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(30),
                    child: AddressAppBarWidget(),
                  )
                : null,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSupSmall,
            horizontal: AppDimensions.paddingMedium,
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Filter())),
            child: HomeSearchBox(context: context),
          ),
        ),
      );
}

class AddressAppBarWidget extends StatelessWidget {
  const AddressAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => homeData.handleAddressNavigation(false),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingDefault,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          spacing: AppDimensions.paddingSmall,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: homeData,
                builder: (context, child) {
                  return Text(
                    homeData.isLoadingAddress
                        ? "is_loading".tr(context: context)
                        : homeData.defaultAddress == null
                            ? "add_default_address".tr(context: context)
                            : "${homeData.defaultAddress?.city_name}, ${homeData.defaultAddress?.state_name}, ${homeData.defaultAddress?.country_name}",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
