import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_serial_no_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/two_states_widget.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';

import '../../../utils/custom_widgets/order_status.dart';
import '../../../utils/custom_widgets/stats_container.dart';
import 'order_listing_viewmodel.dart';

class OrderListingView extends StatelessWidget {
  OrderListingView({super.key});

  final OrderListingViewModel _viewModel = Get.put(OrderListingViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.orders.tr,
        children: [
          SectionHeadingText(headingText: lang_key.ordersList.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: [
                lang_key.all.tr,
                lang_key.pending.tr,
                lang_key.accepted.tr,
                lang_key.ongoing.tr,
                lang_key.completed.tr,
                lang_key.cancelled.tr,
                lang_key.disputed.tr
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

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AllOrdersStatsSection(),
        ListBaseContainer(
          onRefresh: () => _viewModel.fetchSingleStatusOrders(
              null,
              _viewModel.allOrdersTabLimit,
              _viewModel.allOrdersTabPage,
              _viewModel.allOrdersList,
              _viewModel.visibleAllOrdersList
          ),
          onSearch: (value) {},
          expandFirstColumn: false,
          hintText: lang_key.searchOrder.tr,
            controller: _viewModel.allOrderSearchController,
            listData: _viewModel.visibleAllOrdersList,
          columnsNames: [
            lang_key.sl.tr,
            lang_key.date.tr,
            lang_key.totalAmount.tr,
            lang_key.commission.tr,
            lang_key.paymentStatus.tr,
            lang_key.orderStatus.tr,
            lang_key.actions.tr
          ],
          entryChildren: List.generate(_viewModel.visibleAllOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleAllOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleAllOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleAllOrdersList[index].commissionAmount.toString(),),
                  TwoStatesWidget(status: _viewModel.visibleAllOrdersList[index].paymentStatus!, trueStateText: lang_key.paid.tr, falseStateText: lang_key.unpaid.tr,),
                  OrderStatusWidget(orderStatus: _viewModel.visibleAllOrdersList[index].status!),
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
        )
      ],
    );
  }
}

/// All Orders top stats containers section
class _AllOrdersStatsSection extends StatelessWidget {
  _AllOrdersStatsSection();

  final OrderListingViewModel _viewModel = Get.find();
  final double containersWidth = 180;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          StatsContainer(
              statValue: _viewModel.orderStats.value.pending ?? 0,
              statName: lang_key.pending.tr,
            iconData: Icons.pending_actions_rounded,
            width: containersWidth,
          ),
          StatsContainer(
              statValue: _viewModel.orderStats.value.accepted ?? 0,
              statName: lang_key.accepted.tr,
            imagePath: ImagesPaths.acceptedRequests,
            width: containersWidth,
          ),
          StatsContainer(
              statValue: _viewModel.orderStats.value.ongoing ?? 0,
              statName: lang_key.ongoing.tr,
            imagePath: ImagesPaths.ongoingRequests,
            width: containersWidth,
          ),
          StatsContainer(
              statValue: _viewModel.orderStats.value.completed ?? 0,
              statName: lang_key.completed.tr,
            iconData: CupertinoIcons.check_mark_circled,
            width: containersWidth,
          ),
          StatsContainer(
              statValue: _viewModel.orderStats.value.cancelled ?? 0,
              statName: lang_key.cancelled.tr,
            iconData: Icons.cancel_outlined,
            width: containersWidth,
          ),
          StatsContainer(
              statValue: _viewModel.orderStats.value.disputed ?? 0,
              statName: lang_key.disputed.tr,
            iconData: Icons.report_problem_outlined,
            width: containersWidth,
          ),
        ],
      ),
    );
  }
}

/// Pending Orders tab view
class _PendingOrdersTabView extends StatelessWidget {
  _PendingOrdersTabView();

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            onRefresh: () => _viewModel.fetchSingleStatusOrders(
                OrderStatus.pending, _viewModel.pendingTabLimit,
                _viewModel.pendingTabPage,
                _viewModel.allPendingOrdersList,
                _viewModel.visiblePendingOrdersList
            ),
            onSearch: (value) {},
          expandFirstColumn: false,
            controller: _viewModel.pendingOrdersSearchController,
            listData: _viewModel.visiblePendingOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              lang_key.sl.tr,
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ],
          entryChildren: List.generate(_viewModel.visiblePendingOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visiblePendingOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visiblePendingOrdersList[index].customerDetails?.name,),
                  ListEntryItem(text: _viewModel.visiblePendingOrdersList[index].servicemanDetails?.name,),
                  ListEntryItem(text: _viewModel.visiblePendingOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visiblePendingOrdersList[index].commissionAmount.toString(),),
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
      ],
    );
  }
}

/// Accepted Orders tab view
class _AcceptedOrdersTabView extends StatelessWidget {
  _AcceptedOrdersTabView();

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            onRefresh: () => _viewModel.fetchSingleStatusOrders(
                OrderStatus.accepted,
                _viewModel.acceptedTabLimit,
                _viewModel.acceptedTabPage,
                _viewModel.allAcceptedOrdersList,
                _viewModel.visibleAcceptedOrdersList
            ),
            onSearch: (value) {},
            expandFirstColumn: false,
            controller: _viewModel.acceptedOrdersSearchController,
            listData: _viewModel.visibleAcceptedOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              lang_key.sl.tr,
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ],
          entryChildren: List.generate(_viewModel.visibleAcceptedOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleAcceptedOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleAcceptedOrdersList[index].customerDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleAcceptedOrdersList[index].servicemanDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleAcceptedOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleAcceptedOrdersList[index].commissionAmount.toString(),),
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
      ],
    );
  }
}

/// Ongoing Orders tab view
class _OngoingOrdersTabView extends StatelessWidget {
  _OngoingOrdersTabView();

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            onRefresh: () => _viewModel.fetchSingleStatusOrders(
                OrderStatus.ongoing,
                _viewModel.ongoingTabLimit,
                _viewModel.ongoingTabPage,
                _viewModel.allOngoingOrdersList,
                _viewModel.visibleOngoingOrdersList
            ),
            onSearch: (value) {},
            expandFirstColumn: false,
            controller: _viewModel.ongoingOrdersSearchController,
            listData: _viewModel.visibleOngoingOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              lang_key.sl.tr,
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ],
          entryChildren: List.generate(_viewModel.visibleOngoingOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleOngoingOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleOngoingOrdersList[index].customerDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleOngoingOrdersList[index].servicemanDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleOngoingOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleOngoingOrdersList[index].commissionAmount.toString(),),
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
      ],
    );
  }
}

/// Completed Orders tab view
class _CompletedOrdersTabView extends StatelessWidget {
  _CompletedOrdersTabView();

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            onRefresh: () => _viewModel.fetchSingleStatusOrders(
                OrderStatus.completed,
                _viewModel.completedTabLimit,
                _viewModel.completedTabPage,
                _viewModel.allAcceptedOrdersList,
                _viewModel.visibleAcceptedOrdersList
            ),
            onSearch: (value) {},
            expandFirstColumn: false,
            controller: _viewModel.completedOrdersSearchController,
            listData: _viewModel.visibleCompletedOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              lang_key.sl.tr,
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ],
          entryChildren: List.generate(_viewModel.visibleCompletedOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleCompletedOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleCompletedOrdersList[index].customerDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleCompletedOrdersList[index].servicemanDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleCompletedOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleCompletedOrdersList[index].commissionAmount.toString(),),
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
      ],
    );
  }
}

/// Cancelled Orders tab view
class _CancelledOrdersTabView extends StatelessWidget {
  _CancelledOrdersTabView();

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            onRefresh: () => _viewModel.fetchSingleStatusOrders(
                OrderStatus.cancelled, _viewModel.cancelledTabLimit,
                _viewModel.cancelledTabPage,
                _viewModel.allCancelledOrdersList,
                _viewModel.visibleCancelledOrdersList
            ),
            onSearch: (value) {},
            expandFirstColumn: false,
            controller: _viewModel.cancelledOrdersSearchController,
            listData: _viewModel.visibleCancelledOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              lang_key.sl.tr,
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.commission.tr,
              lang_key.actions.tr
            ],
          entryChildren: List.generate(_viewModel.visibleCancelledOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleCancelledOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleCancelledOrdersList[index].customerDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleCancelledOrdersList[index].servicemanDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleCancelledOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleCancelledOrdersList[index].commissionAmount.toString(),),
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
      ],
    );
  }
}

/// Disputed Orders tab view
class _DisputedOrdersTabView extends StatelessWidget {
  _DisputedOrdersTabView();

  final OrderListingViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListBaseContainer(
            onRefresh: () => _viewModel.fetchSingleStatusOrders(
                OrderStatus.disputed, _viewModel.disputedTabLimit,
                _viewModel.disputedTabPage,
                _viewModel.allDisputedOrdersList,
                _viewModel.visibleDisputedOrdersList
            ),
            onSearch: (value) {},
            expandFirstColumn: false,
            controller: _viewModel.disputedOrdersSearchController,
            listData: _viewModel.visibleDisputedOrdersList,
            hintText: lang_key.searchOrder.tr,
            columnsNames: [
              lang_key.sl.tr,
              lang_key.date.tr,
              lang_key.customer.tr,
              lang_key.serviceman.tr,
              lang_key.totalAmount.tr,
              lang_key.reason.tr,
              lang_key.actions.tr
            ],
          entryChildren: List.generate(_viewModel.visibleDisputedOrdersList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleDisputedOrdersList[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleDisputedOrdersList[index].customerDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleDisputedOrdersList[index].servicemanDetails?.name,),
                  ListEntryItem(text: _viewModel.visibleDisputedOrdersList[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleDisputedOrdersList[index].note.toString(),),
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
      ],
    );
  }
}