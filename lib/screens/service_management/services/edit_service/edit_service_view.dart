import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/services/edit_service/edit_service_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../../utils/custom_widgets/screens_base_widget.dart';
import '../../../../utils/custom_widgets/section_heading_text.dart';
import '../../../../utils/custom_widgets/service_form_section.dart';

class EditServiceView extends StatelessWidget {
  EditServiceView({super.key});

  final EditServiceViewModel _viewModel = Get.put(EditServiceViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.servicesList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.services.tr),
          ServiceAdditionSection(
            isBeingEdited: true,
              imageUrl: _viewModel.imageUrl,
              formKey: _viewModel.serviceDetailsFormKey,
              serviceDescController: _viewModel.descController,
              serviceNameController: _viewModel.nameController,
              serviceImage: _viewModel.newImageToUpload,
              onBtnPressed: () => _viewModel.editService()
          ),
        ]
    );
  }
}