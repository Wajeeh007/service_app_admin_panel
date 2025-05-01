import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/helpers/images_paths.dart';
import 'package:service_app_admin_panel/helpers/routes.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../constants.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({super.key, required this.selectedItem});

  final String selectedItem;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SidePanelHeading(text: lang_key.dashboard.tr),
            SidePanelItem(text: lang_key.dashboard.tr, routeName: Routes.dashboard, selectedItem: selectedItem, icon: Icons.dashboard_outlined,),
            SidePanelHeading(text: lang_key.zoneSetup.tr),
            SidePanelItem(text: lang_key.zoneSetup.tr, routeName: Routes.zoneSetup, selectedItem: selectedItem, image: ImagesPaths.zoneManagement,),
            SidePanelHeading(text: lang_key.orderManagement.tr),
            SidePanelItem(text: lang_key.orderManagement.tr, routeName: '', selectedItem: selectedItem, icon: CupertinoIcons.doc,),
            SidePanelHeading(text: lang_key.customerManagement.tr),
            SidePanelItem(text: lang_key.customerList.tr, routeName: '', selectedItem: selectedItem, icon: Icons.list_alt_rounded,),
            SidePanelItem(text: lang_key.suspendedCustomers.tr, routeName: '', selectedItem: selectedItem, icon: Icons.person_off_outlined,),
            SidePanelHeading(text: lang_key.serviceManManagement.tr),
            SidePanelItem(text: lang_key.newRequests.tr, routeName: '', selectedItem: selectedItem, icon: CupertinoIcons.doc_on_clipboard,),
            SidePanelItem(text: lang_key.suspendedServiceMen.tr, routeName: '', selectedItem: selectedItem, icon: Icons.person_off_outlined,),
            SidePanelItem(text: lang_key.suspendedServiceMen.tr, routeName: '', selectedItem: selectedItem, icon: Icons.list_alt_rounded,),
            SidePanelHeading(text: lang_key.serviceManagement.tr),
            SidePanelItem(text: lang_key.servicesList.tr, routeName: '', selectedItem: selectedItem, image: ImagesPaths.servicesList,),
            SidePanelItem(text: lang_key.subServicesList.tr, routeName: '', selectedItem: selectedItem, image: ImagesPaths.subServicesList,),
            SidePanelItem(text: lang_key.itemsList.tr, routeName: '', selectedItem: selectedItem, image: ImagesPaths.item,),
            SidePanelHeading(text: lang_key.withdraws.tr),
            SidePanelItem(text: lang_key.withdrawRequests.tr, routeName: '', selectedItem: selectedItem, icon: CupertinoIcons.money_dollar,),
            SidePanelHeading(text: lang_key.settings.tr),
            SidePanelItem(text: lang_key.businessSetup.tr, routeName: '', selectedItem: selectedItem, icon: Icons.business,),
          ],
        ),
      ),
    );
  }
}

/// Heading text in side panel
class SidePanelHeading extends StatelessWidget {
  const SidePanelHeading({super.key, required this.text});

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
class SidePanelItem extends StatelessWidget {
  const SidePanelItem({
    super.key,
    required this.text,
    required this.routeName,
    required this.selectedItem,
    this.image,
    this.icon,
    this.args,
  }) : assert(icon != null || image != null, 'Either provide icon or image'),
        assert(icon == null || image == null, 'Cannot provide both icon and image');

  final IconData? icon;
  final String text;
  final String? image;
  final String? selectedItem;
  final String routeName;
  final Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedItem == text ? primaryDullYellow : Colors.transparent
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 15),
        minVerticalPadding: 0,
        onTap: () => Get.offNamed(routeName, arguments: args),
        leading: icon != null ? Icon(
          icon!,
          size: 25,
          color: selectedItem == text ? primaryWhite : primaryGrey,
        ) : Image.asset(
          image!,
          width: 25,
          height: 25,
          fit: BoxFit.fill,
          color: selectedItem == text ? primaryWhite : primaryGrey,
        ),
        title: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 15.5,
            color: selectedItem == text ? primaryWhite : primaryGrey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

        ),
      ),
    );
  }
}