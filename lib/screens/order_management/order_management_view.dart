import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/images_paths.dart';

import '../../utils/custom_widgets/stats_container.dart';
import 'order_management_viewmodel.dart';

class OrderManagementView extends StatelessWidget {
  OrderManagementView({super.key});

  final OrderManagementViewModel _viewModel = Get.put(OrderManagementViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.orders.tr,
        overlayPortalControllersAndShowDropDown: [],
        children: [
          SectionHeadingText(headingText: lang_key.ordersList.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: [
                lang_key.allOrders.tr,
                lang_key.pending.tr,
                lang_key.ongoing.tr,
                lang_key.accepted.tr,
                lang_key.completed.tr,
                lang_key.cancelled.tr,
                lang_key.disputes.tr
              ]
          ),
          SizedBox(
            height: 1000,
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _viewModel.tabController,
                children: [
                  _AllOrders(),
                  _PendingOrdersTabView(),
                  _AcceptedOrdersTabView(),
                  _OngoingOrdersTabView(),
                  _CompletedOrdersTabView(),
                  _CancelledOrdersTabView(),
                  _DisputedOrdersTabView(),
                ]
            ),
          )
        ]
    );
  }
}

/// All Orders Tab data
class _AllOrders extends StatelessWidget {
  _AllOrders();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AllOrdersStatsSection(),
        ListBaseContainer(
          expandFirstColumn: false,
          hintText: lang_key.searchOrder.tr,
            formKey: _viewModel.allOrdersFormKey,
            controller: _viewModel.allOrderSearchController,
            listData: _viewModel.allOrdersList,
          columnsNames: [
            'SL',
            lang_key.date.tr,
            lang_key.totalAmount.tr,
            lang_key.commission.tr,
            lang_key.paymentStatus.tr,
            lang_key.orderStatus.tr,
            lang_key.actions.tr
          ],
        )
      ],
    );
  }
}

/// All Orders top stats containers section
class _AllOrdersStatsSection extends StatelessWidget {
  const _AllOrdersStatsSection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          StatsContainer(
              statValue: '0',
              statName: lang_key.pendingRequest.tr,
            iconData: Icons.pending_actions_rounded,
          ),
          StatsContainer(
              statValue: '0',
              statName: lang_key.acceptedRequest.tr,
            imagePath: ImagesPaths.acceptedRequests,
          ),
          StatsContainer(
              statValue: '0',
              statName: lang_key.ongoing.tr,
            imagePath: ImagesPaths.ongoingRequests,
          ),
          StatsContainer(
              statValue: '0',
              statName: lang_key.completed.tr,
            iconData: CupertinoIcons.check_mark_circled,
          ),
          StatsContainer(
              statValue: '0',
              statName: lang_key.cancelled.tr,
            iconData: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }
}

/// Pending Orders tab view
class _PendingOrdersTabView extends StatelessWidget {
  _PendingOrdersTabView();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
          expandFirstColumn: false,
            formKey: _viewModel.pendingOrdersFormKey,
            controller: _viewModel.pendingOrdersSearchController,
            listData: _viewModel.pendingOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}

/// Accepted Orders tab view
class _AcceptedOrdersTabView extends StatelessWidget {
  _AcceptedOrdersTabView();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            expandFirstColumn: false,
            formKey: _viewModel.acceptedOrdersFormKey,
            controller: _viewModel.acceptedOrdersSearchController,
            listData: _viewModel.acceptedOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}

/// Ongoing Orders tab view
class _OngoingOrdersTabView extends StatelessWidget {
  _OngoingOrdersTabView();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            expandFirstColumn: false,
            formKey: _viewModel.ongoingOrdersFormKey,
            controller: _viewModel.ongoingOrdersSearchController,
            listData: _viewModel.ongoingOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.date.tr,
              lang_key.customerName.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}

/// Completed Orders tab view
class _CompletedOrdersTabView extends StatelessWidget {
  _CompletedOrdersTabView();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            expandFirstColumn: false,
            formKey: _viewModel.completedOrdersFormKey,
            controller: _viewModel.completedOrdersSearchController,
            listData: _viewModel.completedOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}

/// Cancelled Orders tab view
class _CancelledOrdersTabView extends StatelessWidget {
  _CancelledOrdersTabView();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            expandFirstColumn: false,
            formKey: _viewModel.cancelledOrdersFormKey,
            controller: _viewModel.cancelledOrdersSearchController,
            listData: _viewModel.cancelledOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}

/// Disputed Orders tab view
class _DisputedOrdersTabView extends StatelessWidget {
  _DisputedOrdersTabView();

  final OrderManagementViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            expandFirstColumn: false,
            formKey: _viewModel.disputedOrdersFormKey,
            controller: _viewModel.disputedOrdersSearchController,
            listData: _viewModel.disputedOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              'SL',
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.reason.tr,
              lang_key.actions.tr
            ]
        ),
      ],
    );
  }
}