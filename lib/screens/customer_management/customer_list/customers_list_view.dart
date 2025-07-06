import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/contact_info_in_list.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/stats_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/user_status.dart';

class CustomersListView extends StatelessWidget {
  CustomersListView({super.key});

  final CustomerListViewModel _viewModel = Get.put(CustomerListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.customersList.tr,
        overlayPortalControllersAndShowDropDown: [],
        children: [
          _CustomerAnalyticsData(),
          SectionHeadingText(headingText: lang_key.customersList.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: [
                lang_key.all.tr,
                lang_key.active.tr,
                lang_key.inactive.tr
              ]
          ),
          SizedBox(
            height: 800,
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _viewModel.tabController,
                children: [
                  _AllCustomersListTabView(),
                  _ActiveCustomersListTabView(),
                  _InActiveCustomersListTabView(),
                ]
            ),
          )
        ],
    );
  }
}

/// Customer Analytics data
class _CustomerAnalyticsData extends StatelessWidget {
  _CustomerAnalyticsData();

  final CustomerListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeadingText(headingText: lang_key.customersAnalyticalData.tr),
        Obx(() => Row(
            spacing: 15,
            children: [
              StatsContainer(
                height: 200,
                statValue: _viewModel.customersAnalyticalData.value.total ?? 0,
                statName: lang_key.totalCustomers.tr,
                iconContainerColor: Colors.purpleAccent,
                iconData: Icons.group,
              ),
              StatsContainer(
                height: 200,
                statValue: _viewModel.customersAnalyticalData.value.active ?? 0,
                statName: lang_key.activeCustomers.tr,
                iconData: Icons.local_activity,
                iconContainerColor: Colors.green,
              ),
              StatsContainer(
                height: 200,
                statValue: _viewModel.customersAnalyticalData.value.inActive ?? 0,
                statName: lang_key.suspendedCustomers.tr,
                iconData: Icons.block,
                iconContainerColor: errorRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// All Customers list tab view
class _AllCustomersListTabView extends StatelessWidget {
  _AllCustomersListTabView();

  final CustomerListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
            onSearch: (value) => _viewModel.searchList(value, _viewModel.allCustomersList, _viewModel.visibleAllCustomersList),
            onRefresh: () => _viewModel.fetchCustomersLists(),
              controller: _viewModel.allCustomersSearchController,
              listData: _viewModel.visibleAllCustomersList,
              expandFirstColumn: false,
              hintText: lang_key.searchCustomer.tr,
              columnsNames: [
                'SL',
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.totalOrders.tr,
                lang_key.totalSpent.tr,
                lang_key.status.tr,
                lang_key.actions.tr
              ],
          entryChildren: List.generate(_viewModel.visibleAllCustomersList.length, (index) {
            return Padding(
                padding: listEntryPadding,
              child: Row(
                children: [
                  ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
                  ListEntryItem(text: _viewModel.visibleAllCustomersList[index].name!,),
                  ContactInfoInList(email: _viewModel.visibleAllCustomersList[index].email!, phoneNo: _viewModel.visibleAllCustomersList[index].phoneNo!,),
                  ListEntryItem(text: _viewModel.visibleAllCustomersList[index].totalOrders.toString(),),
                  ListEntryItem(text: _viewModel.visibleAllCustomersList[index].totalSpent.toString(),),
                  UserStatus(status: _viewModel.visibleAllCustomersList[index].status!),
                  ListEntryItem(
                    child: ListActionsButtons(
                        includeDelete: true,
                        includeEdit: false,
                        includeView: true,
                      onDeletePressed: () => showConfirmationDialog(onPressed: () {}),
                      onViewPressed: () {},
                    ),
                  )
                ],
              ),
            );
          }),
          ),
        ),
      ],
    );
  }
}

/// Active customers list tab view
class _ActiveCustomersListTabView extends StatelessWidget {
  _ActiveCustomersListTabView();

  final CustomerListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onSearch: (value) => _viewModel.searchList(value, _viewModel.allActiveCustomersList, _viewModel.visibleActiveCustomersList),
          onRefresh: () {},
          controller: _viewModel.activeCustomersSearchController,
          listData: _viewModel.visibleActiveCustomersList,
          expandFirstColumn: false,
          hintText: lang_key.searchCustomer.tr,
          columnsNames: [
            'SL',
            lang_key.name.tr,
            lang_key.contactInfo.tr,
            lang_key.gender.tr,
            lang_key.totalOrders.tr,
            lang_key.totalSpent.tr,
            lang_key.actions.tr
          ],
          entryChildren: List.generate(_viewModel.visibleActiveCustomersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
                  ListEntryItem(text: _viewModel.visibleActiveCustomersList[index].name!,),
                  ContactInfoInList(email: _viewModel.visibleActiveCustomersList[index].email!, phoneNo: _viewModel.visibleActiveCustomersList[index].phoneNo!,),
                  ListEntryItem(text: switch(_viewModel.visibleActiveCustomersList[index].gender!) {

                    Gender.male => lang_key.male.tr,
                    Gender.female => lang_key.female.tr,
                    Gender.other => lang_key.other.tr,
                  },),
                  ListEntryItem(text: _viewModel.visibleActiveCustomersList[index].totalOrders.toString(),),
                  ListEntryItem(text: _viewModel.visibleActiveCustomersList[index].totalSpent.toString(),),
                  ListEntryItem(
                    child: ListActionsButtons(
                      includeDelete: true,
                      includeEdit: false,
                      includeView: true,
                      onDeletePressed: () => showConfirmationDialog(onPressed: () {}),
                      onViewPressed: () {},
                    ),
                  )
                ],
              ),
            );
          }),
          ),
        ),
      ],
    );
  }
}

/// Inactive customers list tab view
class _InActiveCustomersListTabView extends StatelessWidget {
  _InActiveCustomersListTabView();

  final CustomerListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onSearch: (value) => _viewModel.searchList(value, _viewModel.allInActiveCustomersList, _viewModel.visibleInActiveCustomersList),
          onRefresh: () {},
          controller: _viewModel.inActiveCustomersSearchController,
          listData: _viewModel.visibleInActiveCustomersList,
          expandFirstColumn: false,
          hintText: lang_key.searchCustomer.tr,
          columnsNames: [
            'SL',
            lang_key.name.tr,
            lang_key.contactInfo.tr,
            lang_key.gender.tr,
            lang_key.totalOrders.tr,
            lang_key.totalSpent.tr,
            lang_key.actions.tr
          ],
          entryChildren: List.generate(_viewModel.visibleActiveCustomersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
                  ListEntryItem(text: _viewModel.visibleInActiveCustomersList[index].name!,),
                  ContactInfoInList(email: _viewModel.visibleInActiveCustomersList[index].email!, phoneNo: _viewModel.visibleActiveCustomersList[index].phoneNo!,),
                  ListEntryItem(text: switch(_viewModel.visibleInActiveCustomersList[index].gender!) {
                    Gender.male => lang_key.male.tr,
                    Gender.female => lang_key.female.tr,
                    Gender.other => lang_key.other.tr,
                  },),
                  ListEntryItem(text: _viewModel.visibleInActiveCustomersList[index].totalOrders.toString(),),
                  ListEntryItem(text: _viewModel.visibleInActiveCustomersList[index].totalSpent.toString(),),
                  ListEntryItem(
                    child: ListActionsButtons(
                      includeDelete: true,
                      includeEdit: false,
                      includeView: true,
                      onDeletePressed: () => showConfirmationDialog(onPressed: () {}),
                      onViewPressed: () {},
                    ),
                  )
                ],
              ),
            );
          }),
          ),
        ),
      ],
    );
  }
}