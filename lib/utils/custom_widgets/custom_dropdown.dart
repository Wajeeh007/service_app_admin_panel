import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';

import '../../models/drop_down_entry.dart';

class CustomDropdown extends StatelessWidget {

  CustomDropdown({
    super.key,
    required this.dropDownList,
    required this.overlayPortalController,
    required this.showDropDown,
    required this.textEditingController,
    this.value,
    this.width = 130,
    this.height = 30,
    this.suffixIconColor = const Color(0xff212121),
    this.hintText = '',
    this.padding,
    this.dropDownFieldColor = primaryWhite,
    this.title,
    this.dropDownWidth,
    this.includeAsterisk = false,
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
  final RxBool showDropDown;
  final String hintText;
  final EdgeInsets? padding;
  final Color dropDownFieldColor;
  final String? title;
  final double? dropDownWidth;
  final bool includeAsterisk;
  final TextEditingController textEditingController;

  final LayerLink link = LayerLink();

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
                    textEditingController: textEditingController,
                    showDropDownValue: showDropDown,
                    dropDownList: dropDownList,
                    width: dropDownWidth ?? width,
                  )
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(title != null && title != '') Padding(
              padding: EdgeInsets.only(left: 8, bottom: 5),
              child: RichText(
                text: TextSpan(
                    text: title!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primaryGrey
                    ),
                    children: includeAsterisk ? [
                      TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: errorRed,
                        ),
                      ),
                    ] : []
                ),
              ),
            ),
            Obx(() => CustomTextFormField(

              controller: textEditingController,
              hint: hintText,
              fillColor: dropDownFieldColor,
              boxConstraints: BoxConstraints(
                  maxWidth: width,
                  minWidth: 120,
                  maxHeight: height,
                  minHeight: height
                ), 
              readOnly: true, 
              suffixIcon: Icon(
                showDropDown.value ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: suffixIconColor,
              ),
              onTap: () => showDropDown.value = !showDropDown.value,
              contentPadding: padding ?? EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// The dropdown menu widget
class Menu extends StatelessWidget {

  final double? width;
  final List<DropDownEntry> dropDownList;
  final RxBool showDropDownValue;
  final TextEditingController textEditingController;

  const Menu({
    super.key,
    required this.dropDownList,
    required this.showDropDownValue,
    required this.textEditingController,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: width ?? 200,
        maxHeight: 180,
      ),
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
                  textEditingController.text = dropDownList[index].label;
                  showDropDownValue.value = false;
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