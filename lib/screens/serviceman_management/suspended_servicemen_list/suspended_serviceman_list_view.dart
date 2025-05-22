import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/suspended_servicemen_list/suspended_serviceman_list_viewmodel.dart';

import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/custom_widgets/screens_base_widget.dart';
import '../../../utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class SuspendedServicemanListView extends StatelessWidget {
  SuspendedServicemanListView({super.key});

  final SuspendedServicemanListViewModel _viewModel = Get.put(SuspendedServicemanListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
      selectedSidePanelItem: lang_key.suspendedServiceMen.tr,
      children: [
        SectionHeadingText(headingText: lang_key.suspendedServiceMen.tr),
        ListBaseContainer(
            includeSearchField: false,
            expandFirstColumn: false,
            listData: _viewModel.suspendedServicemen,
            columnsNames: [
              'SL',
              lang_key.name.tr,
              lang_key.contactInfo.tr,
              lang_key.identificationNo.tr,
              lang_key.dateOfExpiry.tr,
              lang_key.adminNote.tr,
              lang_key.actions.tr,
            ]
        )
      ]
    );
  }
}
