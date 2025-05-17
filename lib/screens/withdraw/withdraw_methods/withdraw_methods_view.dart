import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/heading_in_container_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_dropdown.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/validators.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import 'withdraw_methods_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class WithdrawMethodsView extends StatelessWidget {
  WithdrawMethodsView({super.key});

  final WithdrawMethodsViewModel _viewModel = Get.put(WithdrawMethodsViewModel());
  
  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.methods.tr,
        children: [
          SectionHeadingText(headingText: lang_key.addMethod.tr),
          _NewMethodInformationBaseWidget(),
          SectionHeadingText(headingText: lang_key.methodsList.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: _viewModel.tabsNames,
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _viewModel.tabController,
                children: [
                 _AllMethodsList(),
                 _ActiveMethodsList(),
                 _InActiveMethodsList(),
                ]
            ),
          )
        ]
    );
  }
}

/// Base widget for adding new withdraw method's information
class _NewMethodInformationBaseWidget extends StatelessWidget {
  _NewMethodInformationBaseWidget();

  final WithdrawMethodsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kContainerBoxDecoration,
      padding: basePaddingForContainers,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeadingInContainerText(text: lang_key.setupMethodInfo.tr,),
          _NewMethodInformationTextFormFields(),
          Align(
            alignment: Alignment.centerRight,
            child: CustomMaterialButton(
                onPressed: () {
                  if(_viewModel.newMethodInfoFormKey.currentState!.validate()) {
                    // if(_viewModel.dropDownSelectedValue.value)
                  }
                },
              text: lang_key.saveInformation.tr,
              width: 180,
            ),
          )
        ],
      ),
    );
  }
}

/// Text form fields for adding new method's information
class _NewMethodInformationTextFormFields extends StatelessWidget {
  _NewMethodInformationTextFormFields();

  final WithdrawMethodsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: 20,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 15,
            children: [
              Expanded(
                flex: 2,
                child: CustomTextFormField(
                  hint: lang_key.typeHere.tr,
                  includeAsterisk: true,
                  controller: _viewModel.newMethodFieldNameController,
                  validator: (value) => Validators.validateEmptyField(value),
                  title: lang_key.methodName.tr,
                ),
              ),
              Expanded(
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                          value: _viewModel.makeMethodFieldDefaultValue.value,
                          onChanged: (value) {
                            _viewModel.makeMethodFieldDefaultValue.value = value!;
                          }
                      ),
                    Text(
                      lang_key.makeMethodDefault.tr,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: primaryGrey,
                      ),
                    )
                  ],
                ),
                ),
              ),
            ],
          ),
          _NameTypeAndPlaceholderFormFields(),
        ],
      ),
    );
  }
}

/// Name, Type and Placeholder text fields
class _NameTypeAndPlaceholderFormFields extends StatelessWidget {
  _NameTypeAndPlaceholderFormFields();

  final WithdrawMethodsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomDropdown(
                  textEditingController: _viewModel.fieldTypeTextController,
                  includeAsterisk: true,
                  title: lang_key.inputFieldType.tr,
                  dropDownFieldColor: primaryWhite,
                  dropDownWidth: constraints.maxWidth,
                  height: 58,
                  width: constraints.maxWidth,
                  hintText: lang_key.selectFieldType.tr,
                    dropDownList: _viewModel.newMethodFieldTypeDropdownEntries,
                    overlayPortalController: _viewModel.fieldTypeOverlayPortalController,
                    showDropDown: _viewModel.showDropDown
                );
              }
            )
        ),
        Expanded(
          child: CustomTextFormField(
            includeAsterisk: true,
            title: lang_key.fieldName.tr,
            controller: _viewModel.newMethodFieldNameController,
            validator: (value) => Validators.validateEmptyField(value),
            hint: lang_key.typeHere.tr,
          ),
        ),
        Expanded(
          child: CustomTextFormField(
            includeAsterisk: true,
            title: lang_key.placeholderText.tr,
            controller: _viewModel.newMethodPlaceholderTextController,
            validator: (value) => Validators.validateEmptyField(value),
            hint: lang_key.typeHere.tr,
          ),
        ),
      ],
    );
  }
}

class _AllMethodsList extends StatelessWidget {
  _AllMethodsList();

  final WithdrawMethodsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
          controller: _viewModel.allMethodsSearchController,
            formKey: _viewModel.allMethodsFormKey,
            hintText: lang_key.searchMethod.tr,
            listData: [].obs,
            columnsNames: [
              'SL',
              lang_key.methodName.tr,
              lang_key.fieldType.tr,
              lang_key.isDefault.tr,
              lang_key.status.tr,
              lang_key.actions.tr,
            ]
        )
      ],
    );
  }
}

/// Active Methods list widget
class _ActiveMethodsList extends StatelessWidget {
  _ActiveMethodsList();

  final WithdrawMethodsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
          expandFirstColumn: false,
          controller: _viewModel.activeMethodsSearchController,
            formKey: _viewModel.activeMethodsFormKey,
            hintText: lang_key.searchMethod.tr,
            listData: [].obs,
            columnsNames: [
              'SL',
              lang_key.methodName.tr,
              lang_key.fieldType.tr,
              lang_key.isDefault.tr,
              lang_key.createdDate.tr,
              lang_key.actions.tr,
            ]
        )
      ],
    );
  }
}

/// In-Active methods list widget
class _InActiveMethodsList extends StatelessWidget {
  _InActiveMethodsList();

  final WithdrawMethodsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
          expandFirstColumn: false,
          controller: _viewModel.inActiveMethodsSearchController,
            formKey: _viewModel.inActiveMethodsFormKey,
            hintText: lang_key.searchMethod.tr,
            listData: [].obs,
            columnsNames: [
              'SL',
              lang_key.methodName.tr,
              lang_key.fieldType.tr,
              lang_key.isDefault.tr,
              lang_key.createdDate.tr,
              lang_key.actions.tr,
            ]
        )
      ],
    );
  }
}