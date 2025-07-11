import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_switch.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_list_and_addition/zone_list_and_addition_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/routes.dart';

import '../../../utils/custom_widgets/list_entry_item.dart';
import '../../../utils/custom_widgets/zone_setup_section.dart';

class ZoneListAndAdditionView extends StatelessWidget {
  ZoneListAndAdditionView({super.key});

  final ZoneListAndAdditionViewModel _viewModel = Get.put(ZoneListAndAdditionViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.zoneSetup.tr,
        children: [
          SectionHeadingText(headingText: lang_key.zoneSetup.tr),
          Obx(() => ZoneSetupSection(
            mapController: _viewModel.mapController,
              formKey: _viewModel.zoneNameFormKey,
              nameController: _viewModel.zoneNameController,
              descController: _viewModel.zoneDescController,
              onBtnPressed: () => _viewModel.addNewZone(),
            enableAutoValidation: _viewModel.enableAutoValidation.value,
            ),
          ),
          SectionHeadingText(headingText: lang_key.zoneList.tr),
          Obx(() => ListBaseContainer(
            onRefresh: () => _viewModel.getAllZones(),
              hintText: lang_key.searchZone.tr,
              controller: _viewModel.zoneSearchController,
              listData: _viewModel.visibleZoneList,
              expandFirstColumn: false,
              onSearch: (value) => _viewModel.searchInList(_viewModel.zoneSearchController.text),
              columnsNames: [
                'SL',
                lang_key.zoneName.tr,
                lang_key.orderVolume.tr,
                lang_key.status.tr,
                lang_key.actions.tr
              ],
              entryChildren: List.generate(_viewModel.visibleZoneList.length, (index) {
                return Padding(
                  padding: listEntryPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
                        ListEntryItem(text: _viewModel.visibleZoneList[index].name,),
                        ListEntryItem(text: switch (_viewModel.visibleZoneList[index].orderVolume) {
                          null => lang_key.veryLow.tr,
                          ZoneOrderVolume.veryLow => lang_key.veryLow.tr,
                          ZoneOrderVolume.low => lang_key.low.tr,
                          ZoneOrderVolume.medium => lang_key.medium.tr,
                          ZoneOrderVolume.high => lang_key.high.tr,
                          ZoneOrderVolume.veryHigh => lang_key.veryHigh.tr,
                        },),
                        ListEntryItem(
                          child: CustomSwitch(
                            switchValue: _viewModel.visibleZoneList[index].status!,
                            onChanged: (value) => _viewModel.changeZoneStatus(_viewModel.visibleZoneList[index].id!),
                        ),),
                        ListActionsButtons(
                          includeDelete: true,
                          includeEdit: true,
                          includeView: false,
                          onDeletePressed: () => _viewModel.deleteZone(index),
                          onEditPressed: () => Get.toNamed(Routes.editZone, arguments: {'zoneDetails': _viewModel.visibleZoneList[index]}),
                        )
                      ]
                  ),
                );
              }),
            ),
          )
        ],
    );
  }
}