import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/new_requests/new_requests_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

class NewRequestsView extends StatelessWidget {
  NewRequestsView({super.key});

  final NewRequestsViewModel _viewModel = Get.put(NewRequestsViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      selectedSidePanelItem: lang_key.newRequests.tr,
      children: [
        SectionHeadingText(headingText: lang_key.newRequests.tr),
        ListBaseContainer(
            includeSearchField: false,
            expandFirstColumn: false,
            listData: _viewModel.serviceManNewRequests,
            columnsNames: [
              'SL',
              lang_key.name.tr,
              lang_key.contactInfo.tr,
              lang_key.identificationNo.tr,
              lang_key.dateOfExpiry.tr,
              lang_key.status.tr,
              lang_key.actions.tr
            ]
        )
      ]
    );
  }
}
