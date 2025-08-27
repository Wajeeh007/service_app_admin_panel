import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/custom_widgets/screens_base_widget.dart';
import '../../../utils/custom_widgets/section_heading_text.dart';
import '../../../utils/custom_widgets/withdraw_method_form.dart';
import 'edit_withdraw_method_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class EditWithdrawMethodView extends StatelessWidget {
  EditWithdrawMethodView({super.key});

  final EditWithdrawMethodViewModel _viewModel = Get.put(EditWithdrawMethodViewModel());
  
  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.methods.tr,
        children: [
          SectionHeadingText(headingText: lang_key.addMethod.tr),
          WithdrawMethodForm(
            isBeingEdited: true,
              onPressed: () => _viewModel.editWithdrawMethod(),
              formKey: _viewModel.formKey,
              nameController: _viewModel.methodNameController,
              placeholderTextController: _viewModel.placeholderTextController,
              checkBoxValue: _viewModel.checkBoxValue,
              fieldTypeOverlayPortalController: _viewModel.fieldTypeOverlayPortalController,
              fieldTypeTextController: _viewModel.fieldTypeController,
              showDropDown: _viewModel.showDropDown,
              dropDownValue: _viewModel.dropDownSelectedValue,
              fieldNameTextController: _viewModel.fieldNameController
          ),
        ]
    );
  }
}
