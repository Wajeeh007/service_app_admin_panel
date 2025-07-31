import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_details/customer_details_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/rating_and_value.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';

import '../../../utils/custom_widgets/arc.dart';
import '../../../utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class CustomerDetailsView extends StatelessWidget {
  CustomerDetailsView({super.key});

  final CustomerDetailsViewModel _viewModel = Get.put(CustomerDetailsViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
      selectedSidePanelItem: lang_key.customersList.tr,
      children: [
        SectionHeadingText(headingText: "${lang_key.customer.tr}_"),
        _CustomerInfoAndActivity(),
        _CustomerOrderDetailsContainer(),
        Align(
          alignment: Alignment.bottomRight,
          child: CustomMaterialButton(
            borderColor: errorRed,
            buttonColor: errorRed,
            width: 150,
            text: lang_key.suspend.tr,
              onPressed: () {}
          ),
        )
      ],
    );
  }
}

/// Customer information and activity rate section
class _CustomerInfoAndActivity extends StatelessWidget {
  const _CustomerInfoAndActivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: kContainerBoxDecoration,
      child: Row(
        children: [
          _CustomerInfoSection(),
          _CustomerActivitySection(),
        ],
      ),
    );
  }
}

/// Customer information section.
class _CustomerInfoSection extends StatelessWidget {
  const _CustomerInfoSection();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _SectionHeadingTextAndIcon(text: lang_key.customerInfo.tr),
          _CustomerBasicInfo(),
        ],
      ),
    );
  }
}

/// Customer activity section and rates of activities performed.
class _CustomerActivitySection extends StatelessWidget {
  const _CustomerActivitySection();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _SectionHeadingTextAndIcon(text: lang_key.customerActivityRate.tr),
          Expanded(
            child: Column(
              spacing: 15,
              children: [
                _CustomerActivityRateBar(),
                _RatesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Customer activity rate bar
class _CustomerActivityRateBar extends StatelessWidget {
  const _CustomerActivityRateBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          lang_key.averageActivityRate.tr,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: primaryBlue
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(
                borderRadius: kContainerBorderRadius,
                border: Border.all(
                    color: Colors.transparent,
                    width: 0.1
                ),
                gradient: LinearGradient(
                    colors: [
                      primaryBlue,
                      primaryBlue,
                      primaryGrey.withValues(alpha: 0.2),
                      primaryGrey.withValues(alpha: 0.2)
                    ],
                    stops: [
                      0,
                      0.02,
                      0.02,
                      1
                    ]
                )
            ),
          ),
        ),
        Text('2%', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryBlue))
      ],
    );
  }
}

/// Customer image, name, phone, rating and email
class _CustomerBasicInfo extends StatelessWidget {
  const _CustomerBasicInfo();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        spacing: 15,
        children: [
          ClipRRect(
            borderRadius: kContainerBorderRadius,
            child: Image.asset(ImagesPaths.dummyCustomerImage, height: 200, width: 180,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Name', style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,

                  )),
                  RatingAndValue(ratingValue: 5.0)
                ],
              ),
              Text(
                '+123456789',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey,
                    letterSpacing: 0.4
                ),
              ),
              Text(
                'dummy@example.com',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey,
                    letterSpacing: 0.4
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

/// Customer Order details container
class _CustomerOrderDetailsContainer extends StatelessWidget {
  const _CustomerOrderDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        minWidth: 450,
        minHeight: 200,
        maxHeight: 200,
        maxWidth: 450
      ),
      decoration: kContainerBoxDecoration,
      child: Column(
        spacing: 20,
        children: [
          _SectionHeadingTextAndIcon(text: lang_key.customerOrderDetails.tr),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              _OrderStatisticsTextAndValue(text: lang_key.totalCompletedOrders.tr, value: '0'),
              _OrderStatisticsTextAndValue(text: lang_key.totalCancelledOrders.tr, value: '0'),
              _OrderStatisticsTextAndValue(text: lang_key.highestAmountOrder.tr, value: "\$0.00"),
              _OrderStatisticsTextAndValue(text: lang_key.lowestAmountOrder.tr, value: "\$0.00"),
            ],
          )
        ],
      ),
    );
  }
}


/// Top heading at every section of details
class _SectionHeadingTextAndIcon extends StatelessWidget {
  const _SectionHeadingTextAndIcon({required this.text});

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

/// Mathematical rate stats of the customer
class _RatesSection extends StatelessWidget {
  const _RatesSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        _SingleRateContainer(value: 1, figureText: lang_key.averageSpending.tr, figureUnit: '\$',),
        _SingleRateContainer(value: 0, figureText: lang_key.positiveReviewRate.tr, color: Colors.orange,),
        _SingleRateContainer(value: 0, figureText: lang_key.successRate.tr, color: Colors.green,),
        _SingleRateContainer(value: 0, figureText: lang_key.cancellationRate.tr, color: Colors.redAccent,),
      ],
    );
  }
}

/// Single rate widget
class _SingleRateContainer extends StatelessWidget {
  const _SingleRateContainer({
    required this.value,
    required this.figureText,
    this.figureUnit = '%',
    this.color,
  });

  final double value;
  final String figureUnit;
  final String figureText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: 140,
        maxHeight: 120,
        minHeight: 120,
        minWidth: 140,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: primaryGrey20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Arc(
            figure: value, 
            color: color,
            figureUnit: figureUnit,
          ),
          Text(
            figureText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color ?? primaryBlue,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

/// Order Statistics Text and Value
class _OrderStatisticsTextAndValue extends StatelessWidget {
  const _OrderStatisticsTextAndValue({required this.text, required this.value});

  final String text;
  final String value;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text, 
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: primaryGrey
          ),
        )
      ],
    );
  }
}
