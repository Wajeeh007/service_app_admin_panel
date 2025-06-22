import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/sub_services/sub_service_list/sub_services_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import '../../../../helpers/show_confirmation_dialog.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/custom_widgets/custom_cached_network_image.dart';
import '../../../../utils/custom_widgets/custom_switch.dart';
import '../../../../utils/custom_widgets/list_actions_buttons.dart';
import '../../../../utils/custom_widgets/list_base_container.dart';
import '../../../../utils/custom_widgets/list_entry_item.dart';
import '../../../../utils/custom_widgets/sub_service_form_section.dart';
import '../../../../utils/routes.dart';

class SubServicesListView extends StatelessWidget {
  SubServicesListView({super.key});

  final SubServicesListViewModel _viewModel = Get.put(SubServicesListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.subServicesList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.subServices.tr),
          SubServiceFormSection(
            autoValidator: _viewModel.autoValidate,
              onBtnPressed: () => _viewModel.addNewSubService(),
              formKey: _viewModel.subServiceAdditionFormKey,
              nameController: _viewModel.subServiceNameController,
              serviceTypeController: _viewModel.serviceTypeTextController,
              serviceTypeList: _viewModel.servicesList,
              serviceTypeOverlayController: _viewModel.serviceTypeController,
              showServiceDropDown: _viewModel.showServiceTypeDropDown,
              newImageToUpload: _viewModel.addedServiceImage,
            selectedValue: _viewModel.serviceTypeSelectedId,
          ),
          Obx(() => ListBaseContainer(
              onSearch: (value) => _viewModel.searchTableForSubService(value),
                onRefresh: () => _viewModel.fetchSubServices(),
                controller: _viewModel.searchController,
                listData: _viewModel.visibleSubServicesList,
                hintText: lang_key.searchSubService.tr,
                expandFirstColumn: false,
                columnsNames: [
                  'SL',
                  lang_key.image.tr,
                  lang_key.name.tr,
                  lang_key.serviceType.tr,
                  lang_key.associatedItems.tr,
                  lang_key.status.tr,
                  lang_key.actions.tr
                ],
            entryChildren: List.generate(_viewModel.visibleSubServicesList.length, (index) {

                return Padding(
                  padding: listEntryPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
                      ListEntryItem(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            width: 50,
                            height: 40,
                            child: CustomNetworkImage(imageUrl: _viewModel.visibleSubServicesList[index].image!, boxFit: BoxFit.fitHeight,),
                          )
                      ),
                      ListEntryItem(text: _viewModel.visibleSubServicesList[index].name,),
                      ListEntryItem(text: _viewModel.visibleSubServicesList[index].serviceName,),
                      ListEntryItem(text: _viewModel.visibleSubServicesList[index].associatedItems.toString(),),
                      ListEntryItem(
                        child: CustomSwitch(
                          switchValue: _viewModel.visibleSubServicesList[index].status!,
                          onChanged: (value) => _viewModel.changeServiceStatus(_viewModel.visibleSubServicesList[index].id!),
                        ),
                      ),
                      ListEntryItem(
                        child: ListActionsButtons(
                          includeDelete: true,
                          includeEdit: true,
                          includeView: false,
                          onDeletePressed: () => showConfirmationDialog(onPressed: () => _viewModel.deleteService(_viewModel.visibleSubServicesList[index].id!)),
                          onEditPressed: () => Get.toNamed(Routes.editSubService, arguments: {'subServiceDetails': _viewModel.visibleSubServicesList[index], 'servicesList': _viewModel.servicesList}),
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