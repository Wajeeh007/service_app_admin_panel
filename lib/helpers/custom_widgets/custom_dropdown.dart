
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/constants.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown({
    super.key,
    required this.dropDownList,
    required this.overlayPortalController,
    required this.link,
    required this.selectedItem,
    required this.textEditingController,
    required this.overlayToggleFunc,
    this.width,
    this.value,
    this.height = 50,
    this.buttonColor = Colors.white,
    this.dropDownColor = Colors.white,
    this.buttonBorderColor = const Color(0xFF424242),
    this.dropDownBorderColor = const Color(0xFF424242),
    this.hintText = 'Choose Item',
    this.suffixIconColor = const Color(0xff212121), required this.suffixIcon,
  }) : assert(dropDownList.isEmpty || value == null ||
      dropDownList.where((DropDownEntry item) {
        return item.value == value;
      }).length == 1,
  "There should be exactly one item with [DropdownButton]'s value: "
      '$value. \n'
      'Either zero or 2 or more [DropdownMenuItem]s were detected '
      'with the same value',);

  final double? width;
  final dynamic value;
  final double height;
  final Color buttonColor;
  final Color dropDownColor;
  final Color buttonBorderColor;
  final Color dropDownBorderColor;
  final Color suffixIconColor;
  final String hintText;
  final List<DropDownEntry> dropDownList;
  final OverlayPortalController overlayPortalController;
  final LayerLink link;
  final Rx<dynamic> selectedItem;
  final TextEditingController textEditingController;
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
                    textEditingController: textEditingController,
                    selectedItem: selectedItem,
                    dropDownList: dropDownList,
                    width: width ?? MediaQuery.of(context).size.width,
                  )
              ),
            ),
          );
        },
        child: Obx(() => TextField(
          style: Theme.of(context).textTheme.bodySmall,
          controller: textEditingController,
            decoration: InputDecoration(
              constraints: BoxConstraints(
                  maxWidth: width ?? MediaQuery.of(context).size.width,
                  minWidth: 120,
                  maxHeight: height,
                  minHeight: height - 10
              ),
              fillColor: buttonColor,
              filled: true,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
              ),
              suffixIcon: Icon(suffixIcon.value, size: 20, color: suffixIconColor,),
              enabledBorder: OutlineInputBorder(
                borderRadius: kContainerBorderRadius,
                borderSide: BorderSide(
                  width: 0.1,
                  color: buttonBorderColor
                )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: kContainerBorderRadius,
                  borderSide: BorderSide(
                      width: 0.1,
                      color: buttonBorderColor
                  )
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8)
            ),
            readOnly: true,
            onTap: overlayToggleFunc,
            mouseCursor: SystemMouseCursors.click,
          ),
        ),
      ),
    );
  }
}

/// The dropdown menu widget
class Menu extends StatelessWidget {

  final double? width;
  final List<DropDownEntry> dropDownList;
  final Rx<dynamic> selectedItem;
  final TextEditingController textEditingController;
  final VoidCallback overlayToggleFunc;

  const Menu({
    super.key,
    required this.dropDownList,
    required this.selectedItem,
    required this.textEditingController,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      textEditingController.text = dropDownList[index].value;
                      selectedItem.value = dropDownList[index].value;
                      overlayToggleFunc();
                    },
                    child: Text(
                      dropDownList[index].label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Divider(thickness: 0.7, color: primaryGrey,)
                ],
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