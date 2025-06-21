import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/sub_services/edit_sub_service/edit_sub_service_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../../utils/custom_widgets/screens_base_widget.dart';
import '../../../../utils/custom_widgets/section_heading_text.dart';
import '../../../../utils/custom_widgets/sub_service_form_section.dart';

class EditSubServiceView extends StatelessWidget {
  EditSubServiceView({super.key});

  final EditSubServiceViewModel _viewModel = Get.put(EditSubServiceViewModel());
  
  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.subServicesList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.subServices.tr),
          SubServiceFormSection(
            isBeingEdited: true,
            autoValidator: _viewModel.autoValidate,
            onBtnPressed: () => _viewModel.editService(),
            formKey: _viewModel.subServiceEditFormKey,
            nameController: _viewModel.nameController,
            serviceTypeController: _viewModel.serviceTypeTextController,
            serviceTypeList: _viewModel.servicesList,
            serviceTypeOverlayController: _viewModel.serviceTypeController,
            showServiceDropDown: _viewModel.showServiceTypeDropDown,
            newImageToUpload: _viewModel.addedServiceImage,
            imageUrl: _viewModel.imageUrl,
            selectedValue: _viewModel.serviceTypeSelectedId,
            ),
        ]
    );
  }
}
