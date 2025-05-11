import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/screens/customer_management/suspended_customers_list/suspended_customers_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

class SuspendedCustomersListView extends StatelessWidget {
  SuspendedCustomersListView({super.key});

  final SuspendedCustomersListViewModel _viewModel = Get.put(SuspendedCustomersListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.suspendedCustomers.tr,
        overlayPortalControllersAndShowDropDown: [],
      children: [
        SectionHeadingText(headingText: lang_key.suspendedCustomers.tr),
        ListBaseContainer(
            includeSearchField: false,
            expandFirstColumn: false,
            listData: _viewModel.suspendedCustomersList,
            columnsNames: [
              'SL',
              lang_key.name.tr,
              lang_key.contactInfo.tr,
              lang_key.totalOrders.tr,
              lang_key.totalSpent.tr,
              lang_key.adminNote.tr,
              lang_key.actions.tr,
            ]
        )
      ]
    );
  }
}
