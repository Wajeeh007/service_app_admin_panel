import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/helpers/pick_single_image.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:get/get.dart';
import '../../models/drop_down_entry.dart';
import '../constants.dart';
import '../images_paths.dart';
import '../validators.dart';
import 'custom_cached_network_image.dart';
import 'custom_dropdown.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';
import 'heading_in_container_text.dart';
import 'overlay_icon.dart';

/// Service addition section
class SubServiceFormSection extends StatelessWidget {
  const SubServiceFormSection({
    super.key,
    required this.onBtnPressed,
    required this.formKey,
    required this.nameController,
    required this.serviceTypeController,
    required this.serviceTypeList,
    required this.serviceTypeOverlayController,
    required this.showServiceDropDown,
    this.isBeingEdited = false,
    required this.newImageToUpload,
    this.imageUrl,
    required this.autoValidator,
    required this.selectedValue,
  });

  final VoidCallback onBtnPressed;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController serviceTypeController;
  final List<DropDownEntry> serviceTypeList;
  final OverlayPortalController serviceTypeOverlayController;
  final RxBool showServiceDropDown;
  final bool isBeingEdited;
  final Rx<Uint8List> newImageToUpload;
  final RxString? imageUrl;
  final RxBool autoValidator;
  final RxString selectedValue;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kContainerBoxDecoration,
      padding: basePaddingForContainers,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          _AddServiceNameAndButtonSection(
            onPressed: onBtnPressed,
            formKey: formKey,
            nameController: nameController,
            serviceTypeController: serviceTypeController,
            serviceTypeList: serviceTypeList,
            serviceTypeOverlayController: serviceTypeOverlayController,
            showServiceDropDown: showServiceDropDown,
            autoValidator: autoValidator,
            selectedValue: selectedValue,
          ),
          _AddServiceImageSection(
            isBeingEdited: isBeingEdited,
            imageUrl: imageUrl,
            newImageToUpload: newImageToUpload,
          ),
        ],
      ),
    );
  }
}

/// Add new service name and save info button section
class _AddServiceNameAndButtonSection extends StatelessWidget {
  const _AddServiceNameAndButtonSection({
    required this.onPressed,
    required this.formKey,
    required this.nameController,
    required this.serviceTypeController,
    required this.serviceTypeList,
    required this.serviceTypeOverlayController,
    required this.showServiceDropDown,
    required this.autoValidator,
    required this.selectedValue,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController serviceTypeController;
  final List<DropDownEntry> serviceTypeList;
  final OverlayPortalController serviceTypeOverlayController;
  final RxBool showServiceDropDown;
  final VoidCallback onPressed;
  final RxBool autoValidator;
  final RxString selectedValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeadingInContainerText(text: lang_key.subServiceInfo.tr,),
          Form(
            key: formKey,
            child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 15,
                children: [
                  CustomTextFormField(
                    autoValidateMode: autoValidator.value ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    title: lang_key.subServiceName.tr,
                    controller: nameController,
                    hint: lang_key.typeHere.tr,
                    validator: (value) => Validators.validateEmptyField(value),
                  ),
                  LayoutBuilder(
                      builder: (context, constraints) {
                        return CustomDropdown(
                            textEditingController: serviceTypeController,
                            title: lang_key.serviceType.tr,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            height: 80,
                            width: constraints.maxWidth,
                            dropDownWidth: constraints.maxWidth,
                            dropDownList: serviceTypeList,
                            overlayPortalController: serviceTypeOverlayController,
                            hintText: lang_key.chooseSubService.tr,
                            showDropDown: showServiceDropDown,
                          selectedValueId: selectedValue,
                        );
                      }
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomMaterialButton(
              width: 120,
              onPressed: onPressed,
              text: lang_key.saveInfo.tr,
            ),
          )
        ],
      ),
    );
  }
}

/// Add new service image section
class _AddServiceImageSection extends StatelessWidget {
  const _AddServiceImageSection({
    required this.isBeingEdited,
    required this.newImageToUpload,
    this.imageUrl,
  });

  final Rx<Uint8List> newImageToUpload;
  final bool isBeingEdited;
  final RxString? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        spacing: 15,
        children: [
          HeadingInContainerText(text: lang_key.image.tr,),
          DottedBorder(
              options: RectDottedBorderOptions(
                dashPattern: [14,14],
                strokeWidth: 1.5,
                color: primaryGrey,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => pickSingleImage(imageToUpload: newImageToUpload),
                      child: Obx(() => newImageToUpload.value.isNotEmpty && newImageToUpload.value != Uint8List(0) ?
                      Stack(
                        children: [
                          Image.memory(newImageToUpload.value, fit: BoxFit.fitHeight,),
                          OverlayIcon(iconData: Icons.close, top: 5, right: 5, onPressed: () => newImageToUpload.value = Uint8List(0),),
                        ],
                      ) : isBeingEdited ? CustomNetworkImage(
                        imageUrl: imageUrl!.value,
                        boxFit: BoxFit.fitHeight,
                      ) : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImagesPaths.uploadFile,
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              '${lang_key.uploadFile.tr}...',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: primaryGrey
                              ),
                            )
                          ],
                        )),
                    )
                ),
              ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              lang_key.fileInstructions.tr,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: primaryGrey
              ),
            ),
          )
        ],
      ),
    );
  }
}