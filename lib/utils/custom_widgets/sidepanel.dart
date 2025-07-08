import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../constants.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({
    super.key,
    required this.scrollController,
    required this.selectedItemIndex,
    this.args
  });

  final String selectedItemIndex;
  final Map<String, dynamic>? args;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
      width: MediaQuery.sizeOf(context).width * 0.2,
      decoration: BoxDecoration(
          color: primaryWhite
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SidePanelHeading(text: lang_key.dashboard.tr),
            _SidePanelItem(text: lang_key.dashboard.tr, routeName: Routes.dashboard, selectedItemIndex: selectedItemIndex, icon: Icons.dashboard_outlined, args: args,),
            _SidePanelHeading(text: lang_key.zoneSetup.tr),
            _SidePanelItem(text: lang_key.zoneSetup.tr, routeName: Routes.zoneListAndAddition, selectedItemIndex: selectedItemIndex, image: ImagesPaths.zoneManagement, args: args,),
            _SidePanelHeading(text: lang_key.orderManagement.tr),
            _SidePanelItem(text: lang_key.orders.tr, routeName: Routes.orders, selectedItemIndex: selectedItemIndex, icon: CupertinoIcons.doc, args: args,),
            _SidePanelHeading(text: lang_key.customerManagement.tr),
            _SidePanelItem(text: lang_key.customersList.tr, routeName: Routes.customersList, selectedItemIndex: selectedItemIndex, icon: Icons.list_alt_rounded, args: args,),
            _SidePanelItem(text: lang_key.suspendedCustomers.tr, routeName: Routes.suspendedCustomersList, selectedItemIndex: selectedItemIndex, icon: Icons.person_off_outlined, args: args,),
            _SidePanelHeading(text: lang_key.serviceManManagement.tr),
            _SidePanelItem(text: lang_key.newRequests.tr, routeName: Routes.newServicemanRequests, selectedItemIndex: selectedItemIndex, icon: CupertinoIcons.doc_on_clipboard, args: args,),
            _SidePanelItem(text: lang_key.servicemenList.tr, routeName: Routes.servicemenList, selectedItemIndex: selectedItemIndex, icon: Icons.list_alt_rounded, args: args,),
            _SidePanelItem(text: lang_key.suspendedServiceMen.tr, routeName: Routes.suspendedServicemanList, selectedItemIndex: selectedItemIndex, icon: Icons.person_off_outlined, args: args,),
            _SidePanelHeading(text: lang_key.serviceManagement.tr),
            _SidePanelItem(text: lang_key.servicesList.tr, routeName: Routes.servicesList, selectedItemIndex: selectedItemIndex, image: ImagesPaths.servicesList, args: args,),
            _SidePanelItem(text: lang_key.subServicesList.tr, routeName: Routes.subServicesList, selectedItemIndex: selectedItemIndex, image: ImagesPaths.subServicesList, args: args,),
            _SidePanelItem(text: lang_key.itemsList.tr, routeName: Routes.itemsList, selectedItemIndex: selectedItemIndex, image: ImagesPaths.item, args: args,),
            _SidePanelHeading(text: lang_key.withdraws.tr),
            _SidePanelItem(text: lang_key.methods.tr, routeName: Routes.withdrawMethods, selectedItemIndex: selectedItemIndex, icon: Icons.type_specimen_outlined, args: args,),
            _SidePanelItem(text: lang_key.requests.tr, routeName: Routes.withdrawRequests, selectedItemIndex: selectedItemIndex, icon: CupertinoIcons.money_dollar, args: args,),
            _SidePanelHeading(text: lang_key.settings.tr),
            _SidePanelItem(text: lang_key.businessSetup.tr, routeName: Routes.businessSetup, selectedItemIndex: selectedItemIndex, icon: Icons.business, args: args,),
          ],
        ),
      ),
    );
  }
}

/// Heading text in side panel
class _SidePanelHeading extends StatelessWidget {
  const _SidePanelHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 10, right: 5),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Selectable / Pressable text item in side panel
class _SidePanelItem extends StatelessWidget {
  const _SidePanelItem({
    required this.text,
    required this.routeName,
    required this.selectedItemIndex,
    this.image,
    this.icon,
    this.args,
  }) : assert(icon != null || image != null, 'Either provide icon or image'),
        assert(icon == null || image == null, 'Cannot provide both icon and image');

  final IconData? icon;
  final String text;
  final String? image;
  final String selectedItemIndex;
  final String routeName;
  final Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selectedItemIndex == text ? primaryBlue : Colors.transparent
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 15),
          minVerticalPadding: 0,
          onTap: () => Get.offNamed(routeName, arguments: args,),
          leading: icon != null ? Icon(
            icon!,
            size: 25,
            color: selectedItemIndex == text ? primaryWhite : primaryGrey,
          ) : Image.asset(
            image!,
            width: 25,
            height: 25,
            fit: BoxFit.fill,
            color: selectedItemIndex == text ? primaryWhite : primaryGrey,
          ),
          title: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 15.5,
              color: selectedItemIndex == text ? primaryWhite : primaryGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

          ),
        ),
    );
  }
}