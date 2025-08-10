import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/screens/order_management/order_details/order_details_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../languages/translation_keys.dart' as lang_key;

class OrderDetailsView extends StatelessWidget {
  OrderDetailsView({super.key});

  final OrderDetailsViewModel _viewModel = Get.put(OrderDetailsViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.orders.tr,
        scrollController: _viewModel.scrollController,
        children: [
          SectionHeadingText(headingText: "${lang_key.order.tr}_"),
          SectionHeadingText(headingText: lang_key.activityLog.tr),
          _ActivityLogs(),
          SectionHeadingText(headingText: lang_key.summary.tr),
        ]
    );
  }
}

class _ActivityLogs extends StatelessWidget {
  _ActivityLogs();

  final OrderDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: kContainerBoxDecoration,
      child: Scrollbar(
        thumbVisibility: true,
        controller: _viewModel.activityLogsScrollController,
        child: SingleChildScrollView(
          controller: _viewModel.activityLogsScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: Get.width * 0.75,
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OrderStepHeader(title: lang_key.orderRequest.tr, subtitle: '11:55 AM'),
                    _OrderStepHeader(title: lang_key.requestAccepted.tr, subtitle: '11:57 AM'),
                    _OrderStepHeader(title: lang_key.orderStatus.tr, subtitle: 'Completed'),
                    _OrderStepHeader(title: lang_key.payment.tr, subtitle: 'Venmo'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _StepConnector(isActive: true, showPreviousConnector: false,),
                    _StepConnector(isActive: true),
                    _StepConnector(isActive: true),
                    _StepConnector(isActive: true, showConnector: false,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OrderStepDetail(title: lang_key.orderRequestByCustomer.tr,),
                    _OrderStepDetail(title: lang_key.requestAcceptedByServiceman.tr,),
                    _OrderStepDetail(title: '',),
                    _OrderStepDetail(title: lang_key.paymentSuccessful.tr,),
                  ],
                ),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Header for each step (top row)
class _OrderStepHeader extends StatelessWidget {

  const _OrderStepHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 10,
        children: [
          Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: primaryBlue,
                fontWeight: FontWeight.w600
              )
          ),
          Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: primaryGrey
              )
          ),
        ],
      ),
    );
  }
}

/// Connector line + check icon
class _StepConnector extends StatelessWidget {
  final bool isActive;
  final bool showConnector;
  final bool showPreviousConnector;

  const _StepConnector({
    required this.isActive,
    this.showConnector = true,
    this.showPreviousConnector = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center  ,
        children: [
          if(showPreviousConnector) Expanded(
            child: Container(
              height: 2,
              width: 100,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),
          Expanded(
            flex: showPreviousConnector && showConnector ? 0: 1,
            child: Align(
              alignment: showPreviousConnector && showConnector ? Alignment.center : showPreviousConnector ? Alignment.centerLeft : Alignment.centerRight,
              child: Icon(Icons.check_circle,
                  color: isActive ? Colors.green : Colors.grey, size: 20),
            ),
          ),
          if(showConnector) Expanded(
            child: Container(
              height: 2,
              width: 100,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail section for each step (bottom row)
class _OrderStepDetail extends StatelessWidget {
  final String title;

  const _OrderStepDetail({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: primaryGrey
          )
      ),
    );
  }
}