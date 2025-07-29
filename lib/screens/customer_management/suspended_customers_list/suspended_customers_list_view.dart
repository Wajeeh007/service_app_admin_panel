import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/screens/customer_management/suspended_customers_list/suspended_customers_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_serial_no_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../utils/custom_widgets/contact_info_in_list.dart';
import '../../../utils/custom_widgets/list_actions_buttons.dart';
import '../../../utils/custom_widgets/list_entry_item.dart';

class SuspendedCustomersListView extends StatelessWidget {
  SuspendedCustomersListView({super.key});

  final SuspendedCustomersListViewModel _viewModel = Get.put(SuspendedCustomersListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.suspendedCustomers.tr,
        overlayPortalControllersAndShowDropDown: [],
      children: [
        SectionHeadingText(headingText: lang_key.suspendedCustomers.tr),
        Obx(() => ListBaseContainer(
              onRefresh: () => _viewModel.fetchSuspendedCustomers(),
              includeSearchField: false,
              expandFirstColumn: false,
              listData: _viewModel.suspendedCustomersList,
              columnsNames: [
              lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.totalOrders.tr,
                lang_key.totalSpent.tr,
                lang_key.adminNote.tr,
                lang_key.actions.tr,
              ],
            entryChildren: List.generate(_viewModel.suspendedCustomersList.length, (index) {
              return Padding(
                padding: listEntryPadding,
                child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.suspendedCustomersList[index].name!,),
                    ContactInfoInList(email: _viewModel.suspendedCustomersList[index].email!, phoneNo: _viewModel.suspendedCustomersList[index].phoneNo!,),
                    ListEntryItem(text: _viewModel.suspendedCustomersList[index].totalOrders.toString(),),
                    ListEntryItem(text: _viewModel.suspendedCustomersList[index].totalSpent.toString(),),
                    ListEntryItem(text: _viewModel.suspendedCustomersList[index].suspensionNote!, maxLines: 3,),
                    ListActionsButtons(
                      includeDelete: false,
                      includeEdit: false,
                      includeView: true,
                      onViewPressed: () {},
                    )
                  ],
                ),
              );
            }),
          ),
        )
      ]
    );
  }
}
