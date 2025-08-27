import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/screens/service_management/services/service_list/service_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_cached_network_image.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/routes.dart';

import '../../../../utils/custom_widgets/custom_switch.dart';
import '../../../../utils/custom_widgets/list_actions_buttons.dart';
import '../../../../utils/custom_widgets/list_entry_item.dart';
import '../../../../utils/custom_widgets/list_serial_no_text.dart';
import '../../../../utils/custom_widgets/service_form_section.dart';

class ServiceListView extends StatelessWidget {
  ServiceListView({super.key});

  final ServiceListViewModel _viewModel = Get.put(ServiceListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.servicesList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.services.tr),
          ServiceAdditionSection(
              formKey: _viewModel.serviceAdditionFormKey,
              serviceDescController: _viewModel.serviceDescController,
              serviceNameController: _viewModel.serviceNameController,
              serviceImage: _viewModel.addedServiceImage,
              onBtnPressed: () => _viewModel.addNewService()
          ),
          Obx(() => ListBaseContainer(
                  onRefresh: () {
                    GlobalVariables.showLoader.value = true;
                    _viewModel.fetchServices();
                  },
                  controller: _viewModel.searchController,
                  listData: _viewModel.visibleServicesList,
                  hintText: lang_key.searchService.tr,
                  onSearch: (value) => _viewModel.searchTableForService(value),
                  expandFirstColumn: false,
                  columnsNames: [
                    lang_key.sl.tr,
                    lang_key.image.tr,
                    lang_key.name.tr,
                    lang_key.subServices.tr,
                    lang_key.status.tr,
                    lang_key.actions.tr
                  ],
                entryChildren: List.generate(_viewModel.visibleServicesList.length, (index) {
                  return Padding(
                    padding: listEntryPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListSerialNoText(index: index),
                        ListEntryItem(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            width: 50,
                            height: 40,
                            child: CustomNetworkImage(imageUrl: _viewModel.visibleServicesList[index].image!, boxFit: BoxFit.fitHeight,),
                          )
                        ),
                        ListEntryItem(
                          text: _viewModel.visibleServicesList[index].name,),
                        ListEntryItem(
                          text: _viewModel.visibleServicesList[index].associatedSubServices.toString(),),
                        ListEntryItem(
                          child: CustomSwitch(
                            switchValue: _viewModel.visibleServicesList[index].status!,
                            onChanged: (value) => _viewModel.changeServiceStatus(_viewModel.visibleServicesList[index].id!),
                          ),
                        ),
                        ListActionsButtons(
                          includeDelete: true,
                          includeEdit: true,
                          includeView: false,
                          onDeletePressed: () => showConfirmationDialog(onPressed: () => _viewModel.deleteService(_viewModel.visibleServicesList[index].id!)),
                          onEditPressed: () => Get.toNamed(Routes.editService, arguments: {'serviceDetails': _viewModel.visibleServicesList[index]}),
                        )
                      ],
                    ),
                  );
                }),
              ),
          ),
        ]
    );
  }
}