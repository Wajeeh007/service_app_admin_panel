import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/screens/order_management/order_details/order_details_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/custom_google_maps.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_cached_network_image.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../languages/translation_keys.dart' as lang_key;
import '../../../utils/custom_widgets/rating_and_value.dart';
import '../../../utils/images_paths.dart';

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
          _OrderSummarySection()
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            thumbVisibility: true,
            controller: _viewModel.activityLogsScrollController,
            child: SingleChildScrollView(
                  controller: _viewModel.activityLogsScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1020,
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
                  )
            ),
                );
              }
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

/// Order Summary details, like Customer, Serviceman, location, ordered service
class _OrderSummarySection extends StatelessWidget {
  _OrderSummarySection();

  final OrderDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {

        return Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        _UserDetailsContainer(
                            imageUrl: _viewModel.orderDetails.value.customerDetails?.profileImage ?? '',
                            name: _viewModel.orderDetails.value.customerDetails?.name ?? '',
                            phoneNo: _viewModel.orderDetails.value.customerDetails?.phoneNo ?? '',
                            email: _viewModel.orderDetails.value.customerDetails?.email ?? '',
                            ratingValue: _viewModel.orderDetails.value.customerDetails?.rating ?? 0,
                            headingText: lang_key.customerDetails.tr
                        ),
                        _UserDetailsContainer(
                            imageUrl: _viewModel.orderDetails.value.servicemanDetails?.profileImage ?? '',
                            name: _viewModel.orderDetails.value.servicemanDetails?.name ?? '',
                            phoneNo: _viewModel.orderDetails.value.servicemanDetails?.phoneNo ?? '',
                            email: _viewModel.orderDetails.value.servicemanDetails?.email ?? '',
                            ratingValue: _viewModel.orderDetails.value.servicemanDetails?.rating ?? 0,
                            headingText: lang_key.servicemanDetails.tr
                        ),
                      ],
                    ),
                    _ServiceAndStatusSummary(),
                    if(MediaQuery.sizeOf(context).width < 1150) _LocationContainer()
                  ],
                ),
              ),
              if(MediaQuery.sizeOf(context).width >= 1150) _LocationContainer()
            ],
          ),
        );
      }
    );
  }
}

/// User details container
class _UserDetailsContainer extends StatelessWidget {
  const _UserDetailsContainer({
    required this.imageUrl,
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.ratingValue,
    required this.headingText,
});

  final String imageUrl;
  final String name;
  final String phoneNo;
  final String email;
  final double ratingValue;
  final String headingText;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: kContainerBoxDecoration,
        child: Column(
          spacing: 10,
          children: [
            _ContainerInsideHeadingTextAndIcon(text: headingText,),
            Row(
              spacing: 10,
              children: [
                CustomNetworkImage(
                  imageUrl: imageUrl,
                  height: 80,
                  width: 100,
                  boxFit: BoxFit.fill,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MediaQuery.sizeOf(context).width >= 1200 ? MainAxisAlignment.center : MainAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Row(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          RatingAndValue(ratingValue: ratingValue)
                        ],
                      ),
                      Text(
                        phoneNo,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey,
                            letterSpacing: 0.4
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey,
                            letterSpacing: 0.4
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// Customer and Yabor Details container heading text and image
class _ContainerInsideHeadingTextAndIcon extends StatelessWidget {
  const _ContainerInsideHeadingTextAndIcon({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Image.asset(ImagesPaths.userDetailsSectionHeading, width: 25, height: 25,),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: primaryBlue
          ),
        ),
      ],
    );
  }
}

/// Location Container
class _LocationContainer extends StatelessWidget {
  const _LocationContainer();

  @override
  Widget build(BuildContext context) {

    if(MediaQuery.sizeOf(context).width < 1150) {
      return Container(
        padding: EdgeInsets.all(15),
        decoration: kContainerBoxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              lang_key.location.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if(MediaQuery.sizeOf(context).width >= 1150) _MapAndAddressInColumn(),
            if(MediaQuery.sizeOf(context).width < 1150) _MapAndAddressInRow(),
          ],
        ),
      );
    }
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: kContainerBoxDecoration,
        child: Column(
          spacing: 10,
          children: [
            Text(
              lang_key.location.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if(MediaQuery.sizeOf(context).width >= 1150) _MapAndAddressInColumn(),
            if(MediaQuery.sizeOf(context).width < 1150) _MapAndAddressInRow(),
          ],
        ),
      ),
    );
  }
}

/// Google Map Widget. Created this widget separately so that it does not
/// recreate itself and in-turn another/new Google Map Widget.
class _GoogleMapWidget extends StatelessWidget {
  _GoogleMapWidget();

  final OrderDetailsViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return GoogleMapWidget(
      isBeingEdited: false,
      mapController: _viewModel.mapController,
      willDraw: false,
      mapHeight: MediaQuery.sizeOf(context).width >= 1150 ? 280 : 250,
      mapWidth: MediaQuery.sizeOf(context).width >= 1150 ? double.infinity : 400,
    );
  }
}

/// Map and address text in Column for bigger screen resolution
class _MapAndAddressInColumn extends StatelessWidget {
  const _MapAndAddressInColumn();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        _GoogleMapWidget(),
        Row(
          spacing: 5,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: primaryGrey,
              size: 25,
            ),
            Expanded(
              child: Text(
                "House No 252, Street No 19, Shaheen Housing Scheme, Peshawar",
                //, "${_viewModel.orderDetails.value.addressDetails?.houseApartmentNo ?? ''} ${_viewModel.orderDetails.value.addressDetails?.buildingName ?? ''}, ${_viewModel.orderDetails.value.addressDetails?.streetNo ?? ''}, ${_viewModel.orderDetails.value.addressDetails?.city ?? ''}",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: primaryGrey
                ),
                maxLines: 2,
              ),
            )
          ],
        )
      ],
    );
  }
}

/// Map and address details in Row for smaller screen resolution
class _MapAndAddressInRow extends StatelessWidget {
  _MapAndAddressInRow();
  
  final OrderDetailsViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _GoogleMapWidget(),
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ServiceSummaryRowTextAndValue(text: lang_key.houseOrApartment.tr, value: _viewModel.orderDetails.value.addressDetails?.houseApartmentNo ?? ''),
            _ServiceSummaryRowTextAndValue(text: lang_key.buildingName.tr, value: _viewModel.orderDetails.value.addressDetails?.buildingName ?? ''),
            _ServiceSummaryRowTextAndValue(text: lang_key.street.tr, value: _viewModel.orderDetails.value.addressDetails?.streetNo ?? ''),
            _ServiceSummaryRowTextAndValue(text: lang_key.lane.tr, value: _viewModel.orderDetails.value.addressDetails?.lane ?? ''),
            _ServiceSummaryRowTextAndValue(text: lang_key.city.tr, value: _viewModel.orderDetails.value.addressDetails?.city ?? ''),
          ],
        )
      ],
    );
  }
}


/// Service summary
class _ServiceAndStatusSummary extends StatelessWidget {
  const _ServiceAndStatusSummary();
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            decoration: kContainerBoxDecoration,
            padding: EdgeInsets.all(15),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang_key.serviceSummary.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomNetworkImage(
                        imageUrl: '',
                      height: 50,
                      width: 50,
                      boxFit: BoxFit.fill,
                      shape: BoxShape.circle,
                    ),
                    _ServiceItemAndPriceDetails(),
                    _ServiceSubServiceNameAndOrderStatus()
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}

/// Service Item name, Total price and order date
class _ServiceItemAndPriceDetails extends StatelessWidget {
  _ServiceItemAndPriceDetails();

  final OrderDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang_key.serviceItem.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            DateFormat('dd/MM/yyyy hh:mm a').format(_viewModel.orderDetails.value.createdAt ?? DateTime.now()),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: primaryGrey
            ),
          ),
          Text(
            '${lang_key.total.tr}: \$${_viewModel.orderDetails.value.totalAmount ?? 35}',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}

/// Order status, service and sub-service name details
class _ServiceSubServiceNameAndOrderStatus extends StatelessWidget {
  _ServiceSubServiceNameAndOrderStatus();

  final OrderDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceSummaryRowTextAndValue(
              text: lang_key.orderStatus.tr,
              value: _viewModel.orderDetails.value.status != null ? _viewModel.orderDetails.value.status!.name : OrderStatus.completed.name.toString().capitalizeFirst!
          ),
          _ServiceSummaryRowTextAndValue(
            text: lang_key.paymentStatus.tr,
            value: _viewModel.orderDetails.value.paymentStatus != null && _viewModel.orderDetails.value.paymentStatus! ? lang_key.paid.tr : lang_key.unpaid.tr,
          ),
          _ServiceSummaryRowTextAndValue(
              text: lang_key.service.tr,
              value: _viewModel.orderDetails.value.serviceItem?.serviceName ?? ''
          ),
          _ServiceSummaryRowTextAndValue(
              text: lang_key.subServiceName.tr,
              value: _viewModel.orderDetails.value.serviceItem?.subServiceName ?? ''
          ),
          _ServiceSummaryRowTextAndValue(
              text: lang_key.orderType.tr,
              value: _viewModel.orderDetails.value.orderType?.name.capitalizeFirst ?? OrderType.normal.name.capitalizeFirst!
          ),
        ],
      ),
    );
  }
}

/// Service Summary textual data like status, service and sub-service etc
class _ServiceSummaryRowTextAndValue extends StatelessWidget {
  const _ServiceSummaryRowTextAndValue({
    required this.text,
    required this.value,
  });

  final String text;
  final String value;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$text: ",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: primaryGrey
          ),
        ),
        Text(
            value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: primaryBlue
          ),
          maxLines: 1,
        )
      ],
    );
  }
}
