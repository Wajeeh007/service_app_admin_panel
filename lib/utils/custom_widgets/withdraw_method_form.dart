import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/models/drop_down_entry.dart';
import '../constants.dart';
import '../validators.dart';
import 'custom_dropdown.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';
import 'heading_in_container_text.dart';

/// Base widget for adding new withdraw method's information
class WithdrawMethodForm extends StatelessWidget {
  const   WithdrawMethodForm({
    super.key,
    required this.onPressed,
    required this.formKey,
    required this.nameController,
    required this.placeholderTextController,
    required this.checkBoxValue,
    required this.fieldTypeOverlayPortalController,
    required this.fieldTypeTextController,
    required this.showDropDown,
    required this.dropDownValue,
    required this.fieldNameTextController,
    this.isBeingEdited = false,
  });

  final VoidCallback onPressed;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController placeholderTextController;
  final RxBool checkBoxValue;
  final OverlayPortalController fieldTypeOverlayPortalController;
  final TextEditingController fieldTypeTextController;
  final RxBool showDropDown;
  final RxString dropDownValue;
  final TextEditingController fieldNameTextController;
  final bool isBeingEdited;

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
          _NewMethodInformationTextFormFields(
              formKey: formKey,
              nameController: nameController,
              placeholderTextController: placeholderTextController,
              checkBoxValue: checkBoxValue,
              fieldTypeOverlayPortalController: fieldTypeOverlayPortalController,
              fieldTypeTextController: fieldTypeTextController,
              showDropDown: showDropDown,
              dropDownValue: dropDownValue,
              fieldNameTextController: fieldNameTextController,
            isBeingEdited: isBeingEdited,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CustomMaterialButton(
              onPressed: onPressed,
              text: lang_key.saveInfo.tr,
              width: 150,
            ),
          )
        ],
      ),
    );
  }
}

/// Text form fields for adding new method's information
class _NewMethodInformationTextFormFields extends StatelessWidget {
  const _NewMethodInformationTextFormFields({
    required this.formKey,
    required this.nameController,
    required this.placeholderTextController,
    required this.checkBoxValue,
    required this.fieldTypeOverlayPortalController,
    required this.fieldTypeTextController,
    required this.showDropDown,
    required this.dropDownValue,
    required this.fieldNameTextController,
    required this.isBeingEdited,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController placeholderTextController;
  final RxBool checkBoxValue;
  final OverlayPortalController fieldTypeOverlayPortalController;
  final TextEditingController fieldTypeTextController;
  final RxBool showDropDown;
  final RxString dropDownValue;
  final TextEditingController fieldNameTextController;
  final bool isBeingEdited;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                  controller: nameController,
                  validator: (value) => Validators.validateEmptyField(value),
                  title: lang_key.methodName.tr,
                ),
              ),
              Expanded(
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: checkBoxValue.value,
                        onChanged: (value) => checkBoxValue.value = value!,
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
          _NameTypeAndPlaceholderFormFields(
              fieldTypeTextController: fieldTypeTextController,
              showDropDown: showDropDown,
              dropDownValue: dropDownValue,
              fieldNameTextController: fieldNameTextController,
              placeholderTextController: placeholderTextController,
              fieldTypeOverlayPortalController: fieldTypeOverlayPortalController
          ),
        ],
      ),
    );
  }
}

/// Name, Type and Placeholder text fields
class _NameTypeAndPlaceholderFormFields extends StatelessWidget {
  _NameTypeAndPlaceholderFormFields({
    required this.fieldTypeTextController,
    required this.showDropDown,
    required this.dropDownValue,
    required this.fieldNameTextController,
    required this.placeholderTextController,
    required this.fieldTypeOverlayPortalController,
  });

  final TextEditingController fieldTypeTextController;
  final TextEditingController fieldNameTextController;
  final TextEditingController placeholderTextController;
  final RxBool showDropDown;
  final RxString dropDownValue;
  final OverlayPortalController fieldTypeOverlayPortalController;

  final List<DropDownEntry> newMethodFieldTypeDropdownEntries = [
    DropDownEntry(value: WithdrawMethodFieldType.text.name, label: lang_key.text.tr),
    DropDownEntry(value: WithdrawMethodFieldType.number.name, label: lang_key.number.tr),
    DropDownEntry(value: WithdrawMethodFieldType.email.name, label: lang_key.email.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        Expanded(
            child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomDropdown(
                    textEditingController: fieldTypeTextController,
                    includeAsterisk: true,
                    title: lang_key.inputFieldType.tr,
                    dropDownFieldColor: primaryWhite,
                    dropDownWidth: constraints.maxWidth,
                    height: 58,
                    width: constraints.maxWidth,
                    hintText: lang_key.selectFieldType.tr,
                    dropDownList: newMethodFieldTypeDropdownEntries,
                    overlayPortalController: fieldTypeOverlayPortalController,
                    showDropDown: showDropDown,
                    selectedValueId: dropDownValue,
                  );
                }
            )
        ),
        Expanded(
          child: CustomTextFormField(
            includeAsterisk: true,
            title: lang_key.fieldName.tr,
            controller: fieldNameTextController,
            validator: (value) => Validators.validateEmptyField(value),
            hint: lang_key.typeHere.tr,
          ),
        ),
        Expanded(
          child: CustomTextFormField(
            includeAsterisk: true,
            title: lang_key.placeholderText.tr,
            controller: placeholderTextController,
            validator: (value) => Validators.validateEmptyField(value),
            hint: lang_key.typeHere.tr,
          ),
        ),
      ],
    );
  }
}