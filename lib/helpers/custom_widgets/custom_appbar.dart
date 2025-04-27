import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/constants.dart';

import '../images_paths.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool includeNotification;
  final String? titleText;
  final List<Widget>? action;
  final Widget? leading;
  final double? height;
  final double leadingWidth, elevation;
  final bool? showLeading;
  final Color? bgColor;
  final Widget? bottom;
  final Widget? titleWidget;
  final bool centerTitle;
  final VoidCallback? backBtnOnPressed;
  final bool automaticallyImplyLeading;
  final Alignment? backBtnLeadingAlignment;
  final Color? shadowColor;
  final VoidCallback? onLeadingTap;
  final double? scrollUnderElevation;

  const CustomAppBar(
      {super.key,
        this.titleText,
        this.titleWidget,
        this.centerTitle = true,
        this.includeNotification = true,
        this.action,
        this.leading,
        this.height = 60,
        this.leadingWidth = 40,
        this.elevation = 15,
        this.showLeading = true,
        this.bgColor,
        this.bottom,
        this.backBtnOnPressed,
        this.automaticallyImplyLeading = true,
        this.backBtnLeadingAlignment,
        this.shadowColor,
        this.onLeadingTap,
        this.scrollUnderElevation
      }) : assert((titleText != null && titleWidget == null) || (titleWidget != null && titleText == null) || (titleText == null && titleWidget == null), 'Either remove both titleText and titleWidget property or use one of the two'),
        assert((includeNotification == true && action == null) || (includeNotification == false && action == null) || (includeNotification == false && action != null), 'Cannot provide both action and includeNotification property.\nRemove one to resolve error'),
        assert((leading == null && (showLeading == true || showLeading == false)) || (leading != null && showLeading == true), 'Cannot provide leading and set showLeading to false'),
        assert(backBtnLeadingAlignment == null || leading == null, 'Cannot provide back button alignment and leading.\n Remove one to resolve error'),
        assert((showLeading == false && onLeadingTap == null) || (showLeading == true && (onLeadingTap != null || onLeadingTap == null)), 'Cannot provide onLeadingTap callback when showLeading is false');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      centerTitle: centerTitle,
      shadowColor: shadowColor ?? Theme.of(context).shadowColor,
      actions: action ?? (includeNotification ? [

        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            child: Icon(
              CupertinoIcons.person_crop_circle,
              size: 35,
              color: Colors.grey.shade300,
            ),
          ),
        )
      ] : null),
      title: Image.asset(ImagesPaths.adawatLogo, fit: BoxFit.cover, width: 180,),
      // leading: showLeading! ? Padding(
      //   padding: const EdgeInsets.only(left: 8.0),
      //   child: InkWell(
      //     customBorder: CircleBorder(),
      //     // onTap: onLeadingTap ?? () => Get.back(),
      //     // child: leading ??
      //     //     IconBaseCircularAvatar(
      //     //   radius: 17,
      //     //   icon: Icons.arrow_back_ios_rounded,
      //     // ),
      //   ),
      // ) : SizedBox(),
      bottom: bottom != null ? PreferredSize(preferredSize: preferredSize, child: bottom!) : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height!);

}