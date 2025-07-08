import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/new_requests/new_requests_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/contact_info_in_list.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../utils/custom_widgets/list_serial_no_text.dart';

class NewRequestsView extends StatelessWidget {
  NewRequestsView({super.key});

  final NewRequestsViewModel _viewModel = Get.put(NewRequestsViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
      selectedSidePanelItem: lang_key.newRequests.tr,
      children: [
        SectionHeadingText(headingText: lang_key.newRequests.tr),
        Obx(() => ListBaseContainer(
              onRefresh: () => _viewModel.fetchNewRequests(),
              includeSearchField: false,
              expandFirstColumn: false,
              listData: _viewModel.serviceManNewRequests,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.identificationNo.tr,
                lang_key.dateOfExpiry.tr,
                lang_key.gender.tr,
                lang_key.actions.tr
              ],
            entryChildren: List.generate(_viewModel.serviceManNewRequests.length, (index) {
              return Padding(
                padding: listEntryPadding,
                child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.serviceManNewRequests[index].name),
                    ContactInfoInList(email: _viewModel.serviceManNewRequests[index].email!, phoneNo: _viewModel.serviceManNewRequests[index].phoneNo!),
                    ListEntryItem(text: _viewModel.serviceManNewRequests[index].identificationNo!),
                    ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.serviceManNewRequests[index].identificationExpiry!)),
                    ListEntryItem(text: switch(_viewModel.serviceManNewRequests[index].gender!) {
                      Gender.male => lang_key.male.tr,
                      Gender.female => lang_key.female.tr,
                      Gender.other => lang_key.other.tr,
                    },),
                    ListEntryItem(
                      child: ListActionsButtons(
                          includeDelete: true,
                          includeEdit: false,
                          includeView: true,
                        onDeletePressed: () => showConfirmationDialog(onPressed: () {}, message: lang_key.suspensionConfirmationMessage.tr),
                        onViewPressed: () {},
                      ),
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
