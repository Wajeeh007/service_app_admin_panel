import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/suspended_servicemen_list/suspended_serviceman_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/contact_info_in_list.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/routes.dart';

import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/custom_widgets/list_entry_item.dart';
import '../../../utils/custom_widgets/list_serial_no_text.dart';
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
        Obx(() => ListBaseContainer(
              onRefresh: () => _viewModel.fetchSuspendedServicemen(),
              includeSearchField: false,
              expandFirstColumn: false,
              listData: _viewModel.suspendedServicemen,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.identificationNo.tr,
                lang_key.dateOfExpiry.tr,
                lang_key.adminNote.tr,
                lang_key.actions.tr,
              ],
          entryChildren: List.generate(_viewModel.suspendedServicemen.length, (index) {
            return Padding(
                padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.suspendedServicemen[index].name),
                  ContactInfoInList(email: _viewModel.suspendedServicemen[index].email!, phoneNo: _viewModel.suspendedServicemen[index].phoneNo!),
                  ListEntryItem(text: _viewModel.suspendedServicemen[index].identificationNo),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.suspendedServicemen[index].identificationExpiry!)),
                  ListEntryItem(text: _viewModel.suspendedServicemen[index].suspensionNote, maxLines: 3,),
                  ListActionsButtons(
                    includeDelete: false,
                    includeEdit: false,
                    includeView: true,
                    onViewPressed: () => Get.toNamed(Routes.servicemanDetails,arguments: {'servicemanDetails': _viewModel.suspendedServicemen[index], 'sidePanelItem': lang_key.suspendedServicemen.tr, 'sidePanelRouteName': Routes.servicemenList}),
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