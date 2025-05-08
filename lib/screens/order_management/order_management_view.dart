import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/images_paths.dart';

import 'order_management_viewmodel.dart';

class OrderManagementView extends StatelessWidget {
  OrderManagementView({super.key});

  final OrderManagementViewModel _viewModel = Get.put(OrderManagementViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.orders.tr,
        overlayPortalControllersAndIcons: [],
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeadingText(headingText: lang_key.ordersList.tr),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              constraints: BoxConstraints(
                maxWidth: 650
              ),
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: kContainerBorderRadius,
                border: kContainerBorderSide
              ),
              child: TabBar(
                physics: NeverScrollableScrollPhysics(),
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 3),
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: primaryWhite),
                unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: primaryGrey
                ),
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: kContainerBorderRadius,
                ),
                controller: _viewModel.tabController,
                  tabs: [
                _TabWidget(text: lang_key.allOrders.tr),
                _TabWidget(text: lang_key.pending.tr),
                _TabWidget(text: lang_key.ongoing.tr),
                _TabWidget(text: lang_key.accepted.tr),
                _TabWidget(text: lang_key.completed.tr),
                _TabWidget(text: lang_key.cancelled.tr),
                _TabWidget(text: lang_key.disputes.tr),
              ]),
            ),
            SizedBox(
              height: 1000,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                  controller: _viewModel.tabController,
                  children: [
                    _AllOrders(),
                    _AllOrders(),
                    _AllOrders(),
                    _AllOrders(),
                    _AllOrders(),
                    _AllOrders(),
                    _AllOrders(),
                  ]
              ),
            )
          ],
        )
    );
  }
}

/// Tab widget
class _TabWidget extends StatelessWidget {
  const _TabWidget({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Text(
        text,
      ),
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
          hintText: lang_key.searchOrder.tr,
            formKey: _viewModel.formKey,
            controller: _viewModel.searchController,
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
          _StatsContainer(
              statValue: '0',
              statName: lang_key.pendingRequest.tr,
            iconData: Icons.pending_actions_rounded,
          ),
          _StatsContainer(
              statValue: '0',
              statName: lang_key.acceptedRequest.tr,
            imagePath: ImagesPaths.acceptedRequests,
          ),
          _StatsContainer(
              statValue: '0',
              statName: lang_key.ongoing.tr,
            imagePath: ImagesPaths.ongoingRequests,
          ),
          _StatsContainer(
              statValue: '0',
              statName: lang_key.completed.tr,
            iconData: CupertinoIcons.check_mark_circled,
          ),
          _StatsContainer(
              statValue: '0',
              statName: lang_key.cancelled.tr,
            iconData: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }
}

/// All Orders stats container
class _StatsContainer extends StatelessWidget {
  const _StatsContainer({
    required this.statValue,
    required this.statName,
    this.imagePath,
    this.iconData
  }) : assert(imagePath != null || iconData != null, 'Both imagePath and iconData cannot be provided at the same time'),
      assert(imagePath == null || iconData == null, 'Both imagePath and iconData cannot be null at the same time');

  final String? imagePath;
  final IconData? iconData;
  final String statValue;
  final String statName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 250,
      width: 200,
      decoration: BoxDecoration(
        color: primaryWhite,
        border: kContainerBorderSide,
        borderRadius: kContainerBorderRadius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: kContainerBorderRadius,
            ),
            child: imagePath != null ? Image.asset(
              imagePath!,
              width: 25,
              height: 25,
            ) : Icon(
              iconData!,
              size: 25,
              color: primaryWhite,
            ),
          ),
          Text(
            statValue,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            statName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: primaryGrey
            ),
          ),

        ],
      ),
    );
  }
}
