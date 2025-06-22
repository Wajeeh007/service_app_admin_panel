import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/models/drop_down_entry.dart';
import '../constants.dart';
import '../images_paths.dart';
import '../validators.dart';
import 'custom_cached_network_image.dart';
import 'custom_dropdown.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';
import 'heading_in_container_text.dart';
import 'overlay_icon.dart';

/// Item addition section
class ItemFormSection extends StatelessWidget {
  const ItemFormSection({
    super.key,
    required this.onPressed,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.subServiceTypeController,
    required this.overlayPortalController,
    required this.subServicesList,
    required this.subServiceTypeSelectedId,
    required this.showDropDown,
    required this.newImageToUpload,
    this.isBeingEdited = false,
    this.imageUrl
  });

  final VoidCallback onPressed;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController subServiceTypeController;
  final OverlayPortalController overlayPortalController;
  final RxList<DropDownEntry> subServicesList;
  final RxString subServiceTypeSelectedId;
  final RxBool showDropDown;
  final Rx<Uint8List> newImageToUpload;
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
          _AddItemDetailsAndButtonSection(
              onPressed: onPressed,
              formKey: formKey,
              nameController: nameController,
              priceController: priceController,
              subServiceTypeController: subServiceTypeController,
              overlayPortalController: overlayPortalController,
              subServicesList: subServicesList,
              subServiceTypeSelectedId: subServiceTypeSelectedId,
              showDropDown: showDropDown
          ),
          _AddServiceImageSection(
            newImageToUpload: newImageToUpload,
            isBeingEdited: isBeingEdited,
            imageUrl: imageUrl,
          ),
        ],
      ),
    );
  }
}

/// Add new item name and save info button section
class _AddItemDetailsAndButtonSection extends StatelessWidget {
  const _AddItemDetailsAndButtonSection({
    required this.onPressed,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.subServiceTypeController,
    required this.overlayPortalController,
    required this.subServicesList,
    required this.subServiceTypeSelectedId,
    required this.showDropDown
  });

  final VoidCallback onPressed;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController subServiceTypeController;
  final OverlayPortalController overlayPortalController;
  final RxList<DropDownEntry> subServicesList;
  final RxString subServiceTypeSelectedId;
  final RxBool showDropDown;

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
          _ItemDetailsFields(
              formKey: formKey,
              nameController: nameController,
              priceController: priceController,
              subServiceTypeController: subServiceTypeController,
              overlayPortalController: overlayPortalController,
              subServicesList: subServicesList,
              subServiceTypeSelectedId: subServiceTypeSelectedId,
              showDropDown: showDropDown
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

/// Item details fields
class _ItemDetailsFields extends StatelessWidget {
  const _ItemDetailsFields({
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.subServiceTypeController,
    required this.overlayPortalController,
    required this.subServicesList,
    required this.subServiceTypeSelectedId,
    required this.showDropDown
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController subServiceTypeController;
  final OverlayPortalController overlayPortalController;
  final RxList<DropDownEntry> subServicesList;
  final RxString subServiceTypeSelectedId;
  final RxBool showDropDown;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 15,
        children: [
          CustomTextFormField(
            title: lang_key.subServiceName.tr,
            controller: nameController,
            hint: lang_key.typeHere.tr,
            validator: (value) => Validators.validateEmptyField(value),
          ),
          CustomTextFormField(
            title: lang_key.price.tr,
            controller: priceController,
            hint: lang_key.typeHere.tr,
            keyboardType: TextInputType.number,
            validator: (value) => Validators.validateEmptyField(value),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
          ),
          LayoutBuilder(
              builder: (context, constraints) {
                return CustomDropdown(
                  textEditingController: subServiceTypeController,
                  title: lang_key.serviceType.tr,
                  dropDownFieldColor: primaryWhite,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  height: 50,
                  width: double.infinity,
                  dropDownWidth: constraints.maxWidth,
                  dropDownList: subServicesList,
                  overlayPortalController: overlayPortalController,
                  selectedValueId: subServiceTypeSelectedId,
                  hintText: lang_key.chooseSubService.tr,
                  showDropDown: showDropDown,
                  // selectedValueIndex: _viewModel.subServiceTypeSelectedIndex,
                );
              }
          )
        ],
      ),
    );
  }
}

/// Add new item image section
class _AddServiceImageSection extends StatelessWidget {
  const _AddServiceImageSection({
    required this.isBeingEdited,
    required this.newImageToUpload,
    this.imageUrl,
  });

  final bool isBeingEdited;
  final Rx<Uint8List> newImageToUpload;
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
                      onTap: () => _pickImage(),
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

  void _pickImage() async {
    final image = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        compressionQuality: 1,
        allowedExtensions: ['png', 'jpg', 'jpeg']);

    if(image != null) {
      newImageToUpload.value = image.files.first.bytes!;
    }
  }
}
