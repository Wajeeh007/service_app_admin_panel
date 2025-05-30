import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/zone_setup/edit_zone/edit_zone_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/zone_setup_section.dart';

class EditZoneView extends StatelessWidget {
  EditZoneView({super.key});

  final EditZoneViewModel _viewModel = Get.put(EditZoneViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.zoneSetup.tr,
        children: [
          SectionHeadingText(headingText: lang_key.zoneSetup.tr),
          ZoneSetupSection(
            mapController: _viewModel.mapController,
              onBtnPressed: () => _viewModel.editZone(),
              isBeingEdited: true,
              formKey: _viewModel.formKey,
              nameController: _viewModel.nameController,
              descController: _viewModel.descController,
            includeCancelBtn: true,
            onCancelBtnPressed: () => Get.back(),
            ),
        ]
    );
  }
}
