import 'dart:io' show File;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/items_list/items_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/heading_in_container_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../helpers/show_snackbar.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_widgets/custom_dropdown.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/custom_widgets/custom_text_form_field.dart';
import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/images_paths.dart';
import '../../../utils/validators.dart';

class ItemsListView extends StatelessWidget {
  ItemsListView({super.key});

  final ItemsListViewModel _viewModel = Get.put(ItemsListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.itemsList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.addItemDetails.tr),
          _ItemAdditionSection(),
          ListBaseContainer(
              controller: _viewModel.searchController,
              formKey: _viewModel.searchFormKey,
              listData: _viewModel.itemsList,
              hintText: lang_key.searchItem.tr,
              expandFirstColumn: false,
              columnsNames: [
                'SL',
                lang_key.image.tr,
                lang_key.name.tr,
                lang_key.service.tr,
                lang_key.subServices.tr,
                lang_key.price.tr,
                lang_key.actions.tr
              ]
          )
        ]
    );
  }
}

/// Item addition section
class _ItemAdditionSection extends StatelessWidget {
  const _ItemAdditionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kContainerBoxDecoration,
      padding: basePaddingForContainers,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          _AddItemDetailsAndButtonSection(),
          _AddServiceImageSection(),
        ],
      ),
    );
  }
}

/// Add new item name and save info button section
class _AddItemDetailsAndButtonSection extends StatelessWidget {
  _AddItemDetailsAndButtonSection();

  final ItemsListViewModel _viewModel = Get.find();

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
          _ItemDetailsFields(),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomMaterialButton(
              width: 120,
              onPressed: () {
                if(_viewModel.itemAdditionFormKey.currentState!.validate()) {
                  if(_viewModel.subServiceTypeSelectedIndex != null) {
                    if(_viewModel.addedItemImage.value.path != '') {

                    } else {
                      showSnackBar(
                          message: lang_key.addItemImage.tr,
                          isError: true
                      );
                    }
                  } else {
                    showSnackBar(
                        message: lang_key.addItemSubServiceType.tr,
                        isError: true
                    );
                  }
                }
              },
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
  _ItemDetailsFields();

  final ItemsListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _viewModel.itemAdditionFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 15,
        children: [
          CustomTextFormField(
            title: lang_key.subServiceName.tr,
            controller: _viewModel.itemNameController,
            hint: lang_key.typeHere.tr,
            validator: (value) => Validators.validateEmptyField(value),
          ),
          CustomTextFormField(
            title: lang_key.price.tr,
            controller: _viewModel.itemPriceController,
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
                  textEditingController: _viewModel.serviceTypeController,
                    title: lang_key.serviceType.tr,
                    dropDownFieldColor: primaryWhite,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    height: 50,
                    width: double.infinity,
                    dropDownWidth: constraints.maxWidth,
                    dropDownList: _viewModel.subServicesList,
                    overlayPortalController: _viewModel.subServiceTypeController,
                    value: _viewModel.subServiceTypeSelectedIndex,
                    hintText: lang_key.chooseService.tr,
                    showDropDown: _viewModel.showSubServiceTypeDropDown
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
  _AddServiceImageSection();

  final ItemsListViewModel _viewModel = Get.find();

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
                child: Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _viewModel.addedItemImage.value.path == '' ? Column(
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
                    ) : Image.file(File(_viewModel.addedItemImage.value.path), fit: BoxFit.fitHeight,)
                ),
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
}