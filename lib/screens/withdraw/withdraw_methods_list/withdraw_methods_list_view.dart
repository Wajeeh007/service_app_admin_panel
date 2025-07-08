import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_switch.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/withdraw_method_form.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import '../../../utils/custom_widgets/list_serial_no_text.dart';
import 'withdraw_methods_list_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class WithdrawMethodsListView extends StatelessWidget {
  WithdrawMethodsListView({super.key});

  final WithdrawMethodsListViewModel _viewModel = Get.put(WithdrawMethodsListViewModel());
  
  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.methods.tr,
        children: [
          SectionHeadingText(headingText: lang_key.addMethod.tr),
          WithdrawMethodForm(
              onPressed: () => _viewModel.addWithdrawMethod(),
              formKey: _viewModel.newMethodInfoFormKey,
              nameController: _viewModel.newMethodNameController,
              placeholderTextController: _viewModel.newMethodPlaceholderTextController,
              checkBoxValue: _viewModel.makeMethodFieldDefaultValue,
              fieldTypeOverlayPortalController: _viewModel.fieldTypeOverlayPortalController,
              fieldTypeTextController: _viewModel.fieldTypeTextController,
              showDropDown: _viewModel.showDropDown,
              dropDownValue: _viewModel.dropDownSelectedValue,
              fieldNameTextController: _viewModel.newMethodFieldNameController
          ),
          SectionHeadingText(headingText: lang_key.methodsList.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: _viewModel.tabsNames,
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _viewModel.tabController,
                children: [
                 _AllMethodsList(),
                 _ActiveMethodsList(),
                 _InActiveMethodsList(),
                ]
            ),
          )
        ]
    );
  }
}

/// All Withdraw methods list tab
class _AllMethodsList extends StatelessWidget {
  _AllMethodsList();

  final WithdrawMethodsListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
            onSearch: (value) => _viewModel.searchListForMethod(_viewModel.allMethodsSearchController, _viewModel.visibleAllMethodsList, _viewModel.allMethodsList),
            onRefresh: () => _viewModel.fetchAllMethods(),
            controller: _viewModel.allMethodsSearchController,
              hintText: lang_key.searchMethod.tr,
              listData: _viewModel.visibleAllMethodsList,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.methodName.tr,
                lang_key.fieldType.tr,
                lang_key.isDefault.tr,
                lang_key.status.tr,
                lang_key.actions.tr,
              ],
          expandFirstColumn: false,
          entryChildren: List.generate(_viewModel.visibleAllMethodsList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.visibleAllMethodsList[index].name!,),
                  ListEntryItem(text: switch(_viewModel.visibleAllMethodsList[index].fieldType!) {
                    WithdrawMethodFieldType.text => lang_key.text.tr,
                    WithdrawMethodFieldType.number => lang_key.number.tr,
                    WithdrawMethodFieldType.email => lang_key.email.tr,
                  },),
                  ListEntryItem(text: switch(_viewModel.visibleAllMethodsList[index].isDefault!) {
                    true => lang_key.yes.tr,
                    false => lang_key.no.tr,
                  }),
                  ListEntryItem(
                    child: CustomSwitch(
                        switchValue: _viewModel.visibleAllMethodsList[index].status!,
                        onChanged: (value) => _viewModel.changeWithdrawMethodStatusFromAllList(index)
                    )
                  ),
                  ListEntryItem(
                    child: ListActionsButtons(
                        includeDelete: true,
                        includeEdit: true,
                        includeView: false,
                      onDeletePressed: () => showConfirmationDialog(onPressed: () => _viewModel.deleteWithdrawMethodFromAllList(_viewModel.visibleAllMethodsList[index].id!)),
                      onEditPressed: () => Get.toNamed(Routes.editWithdrawMethod, arguments: {'withdrawMethodDetails': _viewModel.visibleAllMethodsList[index]}),
                    ),
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

/// Active Methods list tab
class _ActiveMethodsList extends StatelessWidget {
  _ActiveMethodsList();

  final WithdrawMethodsListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
              onSearch: (value) => _viewModel.searchListForMethod(_viewModel.activeMethodsSearchController, _viewModel.visibleActiveMethodsList, _viewModel.activeMethodsList),
              onRefresh: () => _viewModel.fetchStatusBasedMethods(true),
              expandFirstColumn: false,
              controller: _viewModel.activeMethodsSearchController,
                hintText: lang_key.searchMethod.tr,
                listData: _viewModel.visibleActiveMethodsList,
                columnsNames: [
                  lang_key.sl.tr,
                  lang_key.methodName.tr,
                  lang_key.fieldType.tr,
                  lang_key.isDefault.tr,
                  lang_key.status.tr,
                  lang_key.actions.tr,
                ],
            entryChildren: List.generate(_viewModel.visibleActiveMethodsList.length, (index) {
              return Padding(
                padding: listEntryPadding.copyWith(bottom: 5),
                child: Row(
                    children: [
                      ListSerialNoText(index: index),
                      ListEntryItem(text: _viewModel.visibleActiveMethodsList[index].name!,),
                      ListEntryItem(text: switch(_viewModel.visibleActiveMethodsList[index].fieldType!) {
                        WithdrawMethodFieldType.text => lang_key.text.tr,
                        WithdrawMethodFieldType.number => lang_key.number.tr,
                        WithdrawMethodFieldType.email => lang_key.email.tr,
                      },),
                      ListEntryItem(text: switch(_viewModel.visibleActiveMethodsList[index].isDefault!) {
                        true => lang_key.yes.tr,
                        false => lang_key.no.tr,
                      }),
                      ListEntryItem(
                          child: CustomSwitch(
                              switchValue: _viewModel.visibleActiveMethodsList[index].status!,
                              onChanged: (value) => _viewModel.changeWithdrawMethodStatusFromActiveOrInActiveList(index, true)
                          ),
                      ),
                      ListEntryItem(
                        child: ListActionsButtons(
                          includeDelete: true,
                          includeEdit: true,
                          includeView: false,
                          onDeletePressed: () => showConfirmationDialog(onPressed: () => _viewModel.deleteWithdrawMethodFromActiveOrInActiveList(_viewModel.visibleActiveMethodsList[index].id!, true)),
                          onEditPressed: () => Get.toNamed(Routes.editWithdrawMethod, arguments: {'withdrawMethodDetails': _viewModel.visibleActiveMethodsList[index]}),
                        ),
                      )
                    ]
                ),
              );
            }),
            ),
        ),
      ],
    );
  }
}

/// In-Active methods list widget
class _InActiveMethodsList extends StatelessWidget {
  _InActiveMethodsList();

  final WithdrawMethodsListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
                onSearch: (value) => _viewModel.searchListForMethod(_viewModel.inActiveMethodsSearchController, _viewModel.visibleInActiveMethodsList, _viewModel.inActiveMethodsList),
                onRefresh: () => _viewModel.fetchStatusBasedMethods(false),
              expandFirstColumn: false,
              controller: _viewModel.inActiveMethodsSearchController,
                hintText: lang_key.searchMethod.tr,
                listData: _viewModel.visibleInActiveMethodsList,
                columnsNames: [
                  lang_key.sl.tr,
                  lang_key.methodName.tr,
                  lang_key.fieldType.tr,
                  lang_key.isDefault.tr,
                  lang_key.status.tr,
                  lang_key.actions.tr,
                ],
          entryChildren: List.generate(_viewModel.visibleInActiveMethodsList.length, (index) {
            return Padding(
              padding: listEntryPadding.copyWith(bottom: 5),
              child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.visibleInActiveMethodsList[index].name!,),
                    ListEntryItem(text: switch(_viewModel.visibleInActiveMethodsList[index].fieldType!) {
                      WithdrawMethodFieldType.text => lang_key.text.tr,
                      WithdrawMethodFieldType.number => lang_key.number.tr,
                      WithdrawMethodFieldType.email => lang_key.email.tr,
                    },),
                    ListEntryItem(text: switch(_viewModel.visibleInActiveMethodsList[index].isDefault!) {
                      true => lang_key.yes.tr,
                      false => lang_key.no.tr,
                    }),
                    ListEntryItem(
                      child: CustomSwitch(
                          switchValue: _viewModel.visibleInActiveMethodsList[index].status!,
                          onChanged: (value) => _viewModel.changeWithdrawMethodStatusFromActiveOrInActiveList(index, false)
                      ),
                    ),
                    ListEntryItem(
                      child: ListActionsButtons(
                        includeDelete: true,
                        includeEdit: true,
                        includeView: false,
                        onDeletePressed: () => showConfirmationDialog(onPressed: () => _viewModel.deleteWithdrawMethodFromActiveOrInActiveList(_viewModel.visibleInActiveMethodsList[index].id!, false)),
                        onEditPressed: () => Get.toNamed(Routes.editWithdrawMethod, arguments: {'withdrawMethodDetails': _viewModel.visibleInActiveMethodsList[index]}),
                      ),
                    )
                  ]
              ),
            );
          }),
            ),
        ),
      ],
    );
  }
}