import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/custom_cached_network_image.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/overlay_icon.dart';
import '../constants.dart';
import '../images_paths.dart';
import '../validators.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';
import 'heading_in_container_text.dart';

/// Service addition section
class ServiceAdditionSection extends StatelessWidget {
  const ServiceAdditionSection({
    super.key,
    required this.formKey,
    required this.serviceDescController,
    required this.serviceNameController,
    required this.serviceImage,
    required this.onBtnPressed,
    // required this.onPickImage,
    this.isBeingEdited = false,
    this.imageUrl,
  }) : assert((isBeingEdited == true && imageUrl != null) || (isBeingEdited == false && imageUrl == null), 'Image URL can only be provided if you\'re editing a service.');

  final GlobalKey<FormState> formKey;
  final TextEditingController serviceNameController;
  final TextEditingController serviceDescController;
  final Rx<Uint8List> serviceImage;
  final VoidCallback onBtnPressed;
  // final VoidCallback onPickImage;
  final bool isBeingEdited;
  final RxString? imageUrl;

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
            formKey: formKey,
            nameController: serviceNameController,
            descController: serviceDescController,
            onBtnPressed: onBtnPressed,
          ),
          _AddServiceImageSection(
            isBeingEdited: isBeingEdited,
            addedServiceImage: serviceImage,
            imageUrl: imageUrl,
          ),
        ],
      ),
    );
  }
}

/// Add new service name and save info button section
class _AddServiceNameAndButtonSection extends StatelessWidget {
  const _AddServiceNameAndButtonSection({
    required this.formKey,
    required this.nameController,
    required this.descController,
    required this.onBtnPressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descController;
  final VoidCallback onBtnPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeadingInContainerText(text: lang_key.serviceInfo.tr,),
          Form(
            key: formKey,
            child: Column(
              spacing: 15,
              children: [
                CustomTextFormField(
                  title: lang_key.serviceName.tr,
                  controller: nameController,
                  hint: lang_key.typeHere.tr,
                  validator: (value) => Validators.validateEmptyField(value),
                ),
                CustomTextFormField(
                  minLines: 5,
                  maxLines: 10,
                  title: lang_key.serviceDesc.tr,
                  controller: descController,
                  hint: lang_key.typeBriefServiceDesc.tr,
                  validator: (value) => Validators.validateEmptyField(value),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomMaterialButton(
              width: 120,
              onPressed: onBtnPressed,
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
    required this.addedServiceImage,
    this.imageUrl,
  });

  final bool isBeingEdited;
  final Rx<Uint8List> addedServiceImage;
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
                      onTap: () => pickImage(),
                      child: Obx(() => addedServiceImage.value.isNotEmpty && addedServiceImage.value != Uint8List(0) ? Stack(
                        children: [
                          Image.memory(addedServiceImage.value, fit: BoxFit.fitHeight,),
                          OverlayIcon(iconData: Icons.close, top: 5, right: 5, onPressed: () => addedServiceImage.value = Uint8List(0),),
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
                          ),
                      ),
                    )
                ),
              )
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

  void pickImage() async {
    final image = await FilePicker.platform.pickFiles(
      type: FileType.custom,
        compressionQuality: 1,
        allowedExtensions: ['png', 'jpg', 'jpeg']);

    if(image != null) {
      addedServiceImage.value = image.files.first.bytes!;
    }
  }
}