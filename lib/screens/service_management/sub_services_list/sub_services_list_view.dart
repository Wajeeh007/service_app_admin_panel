import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/sub_services_list/sub_services_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_dropdown.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/helper_functions/show_snackbar.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/custom_widgets/custom_text_form_field.dart';
import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/images_paths.dart';
import '../../../utils/validators.dart';

class SubServicesListView extends StatelessWidget {
  SubServicesListView({super.key});

  final SubServicesListViewModel _viewModel = Get.put(SubServicesListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.subServicesList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.subServices.tr),
          _SubServiceAdditionSection(),
          ListBaseContainer(
              controller: _viewModel.searchController,
              formKey: _viewModel.searchFormKey,
              listData: _viewModel.subCategoriesList,
              hintText: lang_key.searchSubService.tr,
              expandFirstColumn: false,
              columnsNames: [
                'SL',
                lang_key.image.tr,
                lang_key.name.tr,
                lang_key.subServices.tr,
                lang_key.createdDate.tr,
                lang_key.actions.tr
              ]
          )
        ]
    );
  }
}

/// Service addition section
class _SubServiceAdditionSection extends StatelessWidget {
  const _SubServiceAdditionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kContainerBoxDecoration,
      padding: basePaddingForContainers,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          _AddServiceNameAndButtonSection(),
          _AddServiceImageSection(),
        ],
      ),
    );
  }
}

/// Add new service name and save info button section
class _AddServiceNameAndButtonSection extends StatelessWidget {
  _AddServiceNameAndButtonSection();

  final SubServicesListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            lang_key.subServiceInfo.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
          Form(
            key: _viewModel.serviceAdditionFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 15,
              children: [
                CustomTextFormField(
                  title: lang_key.subServiceName.tr,
                  controller: _viewModel.serviceAdditionController,
                  hint: lang_key.typeHere.tr,
                  validator: (value) => Validators.validateEmptyField(value),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomDropdown(
                      title: lang_key.serviceType.tr,
                      dropDownFieldColor: primaryWhite,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        height: 50,
                        width: double.infinity,
                        dropDownWidth: constraints.maxWidth,
                        dropDownList: _viewModel.servicesList,
                        overlayPortalController: _viewModel.serviceTypeController,
                        link: _viewModel.serviceTypeLink,
                        selectedItemIndex: _viewModel.serviceTypeSelectedIndex,
                        hintText: lang_key.chooseService.tr,
                        overlayToggleFunc: () => _viewModel.toggleOverlay(
                            overlayPortalController: _viewModel.serviceTypeController,
                            showDropDown: _viewModel.showServiceTypeDropDown
                        ),
                        showDropDown: _viewModel.showServiceTypeDropDown
                    );
                  }
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomMaterialButton(
              width: 120,
              onPressed: () {
                if(_viewModel.serviceAdditionFormKey.currentState!.validate()) {
                  if(_viewModel.serviceTypeSelectedIndex != null) {
                    if(_viewModel.addedServiceImage.value.path != '') {

                    } else {
                      showSnackBar(
                          message: lang_key.addSubServiceImage.tr,
                          isError: true
                      );
                    }
                  } else {
                    showSnackBar(
                        message: lang_key.addServiceError.tr,
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


/// Add new service image section
class _AddServiceImageSection extends StatelessWidget {
  _AddServiceImageSection();

  final SubServicesListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        spacing: 15,
        children: [
          Text(
            lang_key.image.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(10),
              dashPattern: [14,14],
              strokeWidth: 1.5,
              color: primaryGrey,
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _viewModel.addedServiceImage.value.path == '' ? Column(
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
                    ) : Image.file(File(_viewModel.addedServiceImage.value.path), fit: BoxFit.fitHeight,)
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