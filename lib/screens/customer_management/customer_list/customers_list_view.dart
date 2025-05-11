import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/stats_container.dart';

class CustomersListView extends StatelessWidget {
  CustomersListView({super.key});

  final CustomerListViewModel _viewModel = Get.put(CustomerListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.customersList.tr,
        overlayPortalControllersAndShowDropDown: [],
        children: [
          _CustomerAnalyticsData(),
          SectionHeadingText(headingText: lang_key.customersList.tr),
          CustomTabBar(
              maxWidth: 230,
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
  const _CustomerAnalyticsData();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeadingText(headingText: lang_key.customersAnalyticalData.tr),
        Row(
          spacing: 15,
          children: [
            StatsContainer(
              height: 200,
              statValue: '0',
              statName: lang_key.totalCustomers.tr,
              iconContainerColor: Colors.purpleAccent,
              iconData: Icons.group,
            ),
            StatsContainer(
              height: 200,
              statValue: '0',
              statName: lang_key.activeCustomers.tr,
              iconData: Icons.local_activity,
              iconContainerColor: Colors.green,
            ),
            StatsContainer(
              height: 200,
              statValue: '0',
              statName: lang_key.suspendedCustomers.tr,
              iconData: Icons.block,
              iconContainerColor: errorRed,
            ),
          ],
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
        ListBaseContainer(
            formKey: _viewModel.allCustomersFormKey,
            controller: _viewModel.allCustomersSearchController,
            listData: _viewModel.allCustomers,
            expandFirstColumn: false,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.name.tr,
              lang_key.contactInfo.tr,
              lang_key.totalOrders.tr,
              lang_key.totalSpent.tr,
              lang_key.status.tr,
              lang_key.actions.tr
            ]
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
        ListBaseContainer(
            formKey: _viewModel.activeCustomersFormKey,
            controller: _viewModel.activeCustomersSearchController,
            listData: _viewModel.activeCustomers,
            expandFirstColumn: false,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.name.tr,
              lang_key.contactInfo.tr,
              lang_key.gender.tr,
              lang_key.totalOrders.tr,
              lang_key.totalSpent.tr,
              lang_key.actions.tr
            ]
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
        ListBaseContainer(
            formKey: _viewModel.inActiveCustomersFormKey,
            controller: _viewModel.inActiveCustomersSearchController,
            listData: _viewModel.inActiveCustomers,
            expandFirstColumn: false,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.name.tr,
              lang_key.contactInfo.tr,
              lang_key.gender.tr,
              lang_key.totalOrders.tr,
              lang_key.totalSpent.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}
