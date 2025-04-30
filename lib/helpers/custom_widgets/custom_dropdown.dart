import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/constants.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown({
    super.key,
    required this.dropDownList,
    required this.overlayPortalController,
    required this.link,
    required this.selectedItemIndex,
    required this.overlayToggleFunc,
    required this.suffixIcon,
    this.width = 130,
    this.value,
    this.height = 30,
    this.suffixIconColor = const Color(0xff212121),
  }) : assert(dropDownList.isEmpty || value == null ||
      dropDownList.where((DropDownEntry item) {
        return item.value == value;
      }).length == 1,
  "There should be exactly one item with [DropdownButton]'s value: "
      '$value. \n'
      'Either zero or 2 or more [DropdownMenuItem]s were detected '
      'with the same value',);

  final double width;
  final dynamic value;
  final double height;
  final Color suffixIconColor;
  final List<DropDownEntry> dropDownList;
  final OverlayPortalController overlayPortalController;
  final LayerLink link;
  final RxInt selectedItemIndex;
  final Rx<IconData> suffixIcon;
  final VoidCallback overlayToggleFunc;

  @override
  Widget build(BuildContext context) {

    return CompositedTransformTarget(
      link: link,
      child: OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: link,
            targetAnchor: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Menu(
                    overlayToggleFunc: overlayToggleFunc,
                    selectedItemIndex: selectedItemIndex,
                    dropDownList: dropDownList,
                    width: width,
                  )
              ),
            ),
          );
        },
        child: Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          constraints: BoxConstraints(
              maxWidth: width,
              minWidth: 120,
              maxHeight: height,
              minHeight: height - 10
          ),
          decoration: BoxDecoration(
            color: primaryGrey20,
            borderRadius: kContainerBorderRadius,
            border: kContainerBorderSide
          ),
          child: InkWell(
            onTap: overlayToggleFunc,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dropDownList[selectedItemIndex.value].label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Icon(
                  suffixIcon.value,
                  size: 22,
                  color: suffixIconColor,
                )
              ],
            ),
          ),
        )
        ),
      ),
    );
  }
}

/// The dropdown menu widget
class Menu extends StatelessWidget {

  final double? width;
  final List<DropDownEntry> dropDownList;
  final RxInt selectedItemIndex;
  final VoidCallback overlayToggleFunc;

  const Menu({
    super.key,
    required this.dropDownList,
    required this.selectedItemIndex,
    required this.overlayToggleFunc,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: width ?? 200 ,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade600, width: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 8)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(dropDownList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: InkWell(
                onTap: () {
                  selectedItemIndex.value = index;
                  overlayToggleFunc();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dropDownList[index].label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                    if(index != dropDownList.length - 1) Divider(thickness: 0.7, color: primaryGrey,)
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

void tap(OverlayPortalController overlayPortalController, Rx<IconData> suffixIcon) {
  overlayPortalController.toggle();
  if(overlayPortalController.isShowing) {
    suffixIcon.value = Icons.keyboard_arrow_up_rounded;
  } else {
    suffixIcon.value = Icons.keyboard_arrow_down_rounded;
  }
}

class DropDownEntry {
  final dynamic value;
  final String label;

  DropDownEntry({required this.value, required this.label});
}