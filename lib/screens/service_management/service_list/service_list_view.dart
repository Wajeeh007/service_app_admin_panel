import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/service_list/service_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/heading_in_container_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/validators.dart';

import '../../../utils/images_paths.dart';

class ServiceListView extends StatelessWidget {
  ServiceListView({super.key});

  final ServiceListViewModel _viewModel = Get.put(ServiceListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.servicesList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.services.tr),
          _ServiceAdditionSection(),
          ListBaseContainer(
              controller: _viewModel.searchController,
              formKey: _viewModel.searchFormKey,
              listData: _viewModel.servicesList,
              hintText: lang_key.searchService.tr,
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
class _ServiceAdditionSection extends StatelessWidget {
  const _ServiceAdditionSection();

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

  final ServiceListViewModel _viewModel = Get.find();

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
            key: _viewModel.serviceAdditionFormKey,
            child: CustomTextFormField(
              title: lang_key.serviceName.tr,
              controller: _viewModel.serviceAdditionController,
              hint: lang_key.typeHere.tr,
              validator: (value) => Validators.validateEmptyField(value),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomMaterialButton(
              width: 120,
              onPressed: () {
                if(_viewModel.serviceAdditionFormKey.currentState!.validate()) {

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

  final ServiceListViewModel _viewModel = Get.find();

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
