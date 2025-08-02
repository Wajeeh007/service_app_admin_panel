import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/helpers/determine_list_height.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_details/customer_details_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/rating_and_value.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';

import '../../../utils/custom_widgets/arc.dart';
import '../../../utils/custom_widgets/list_actions_buttons.dart';
import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/custom_widgets/list_entry_item.dart';
import '../../../utils/custom_widgets/list_serial_no_text.dart';
import '../../../utils/custom_widgets/order_status.dart';
import '../../../utils/custom_widgets/rating_stars.dart';
import '../../../utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../utils/custom_widgets/two_states_widget.dart';

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
        CustomTabBar(
            controller: _viewModel.mainTabController,
            onChanged: (value) {
              switch(value) {
                case 0: GlobalVariables.listHeight.value = 200;
                case 1: listSize(length: _viewModel.visibleCustomerOrders.length);
                case 2: listSize(length: _viewModel.transactions.length );
                case 3: GlobalVariables.listHeight.value = 600 + (_viewModel.reviewsTabController.index == 0 ? _viewModel.reviewsByServiceman.length * 40 : _viewModel.reviewsToServiceman.length * 40);
              }
            },
            tabsNames: [
              lang_key.overView.tr,
              lang_key.orders.tr,
              lang_key.transactions.tr,
              lang_key.reviews.tr,
            ]
        ),
        Obx(() => SizedBox(
            height: GlobalVariables.listHeight.value,
            child: TabBarView(
              controller: _viewModel.mainTabController,
                children: [
                  _CustomerOverviewTab(),
                  _CustomerOrdersTab(),
                  _CustomerTransactionsTab(),
                  _CustomerReviewsTab(),
                ]
            ),
          ),
        ),
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
          _ContainerInsideHeadingTextAndIcon(text: lang_key.customerInfo.tr),
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
          _ContainerInsideHeadingTextAndIcon(text: lang_key.customerActivityRate.tr),
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
class _CustomerOverviewTab extends StatelessWidget {
  const _CustomerOverviewTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
              _ContainerInsideHeadingTextAndIcon(text: lang_key.customerOrderDetails.tr),
              Column(
                mainAxisSize: MainAxisSize.min,
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
        ),
      ],
    );
  }
}

/// Customer Orders tab
class _CustomerOrdersTab extends StatelessWidget {
  _CustomerOrdersTab();

  final CustomerDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onRefresh: () => _viewModel.fetchCustomerOrders(),
          onSearch: (value) {},
          expandFirstColumn: false,
          hintText: lang_key.searchOrder.tr,
          controller: _viewModel.ordersSearchController,
          listData: _viewModel.visibleCustomerOrders,
          columnsNames: [
            lang_key.sl.tr,
            lang_key.date.tr,
            lang_key.totalAmount.tr,
            lang_key.commission.tr,
            lang_key.paymentStatus.tr,
            lang_key.orderStatus.tr,
            lang_key.actions.tr
          ],
          entryChildren: List.generate(_viewModel.visibleCustomerOrders.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleCustomerOrders[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleCustomerOrders[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleCustomerOrders[index].commissionAmount.toString(),),
                  TwoStatesWidget(status: _viewModel.visibleCustomerOrders[index].paymentStatus!, trueStateText: lang_key.paid.tr, falseStateText: lang_key.unpaid.tr,),
                  OrderStatusWidget(orderStatus: _viewModel.visibleCustomerOrders[index].status!),
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
        ),
      ],
    );
  }
}

/// Customer Transactions Tab
class _CustomerTransactionsTab extends StatelessWidget {
  _CustomerTransactionsTab();

  final CustomerDetailsViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return ListBaseContainer(
        onRefresh: () {},
        includeSearchField: false,
        expandFirstColumn: false,
        listData: _viewModel.transactions,
        columnsNames: [
          lang_key.sl.tr,
          lang_key.date.tr,
          lang_key.totalAmount.tr,
          lang_key.commission.tr,
          lang_key.paymentStatus.tr,
        ],
    );
  }
}

/// Customer Reviews Tab
class _CustomerReviewsTab extends StatelessWidget {
  _CustomerReviewsTab();

  final CustomerDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 15,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          constraints: BoxConstraints(
            minWidth: double.infinity,
            maxHeight: 200,
            minHeight: 200
          ),
          decoration: kContainerBoxDecoration,
          child: Column(
            children: [
              _ContainerInsideHeadingTextAndIcon(text: lang_key.customerRating.tr, iconImage: ImagesPaths.customerRating,),
              Expanded(child: _RatingSection())
            ],
          ),
        ),
        SectionHeadingText(headingText: lang_key.reviews.tr),
        CustomTabBar(
            controller: _viewModel.reviewsTabController,
            tabsNames: [
              lang_key.reviewFromServiceman.tr,
              lang_key.reviewGivenToServiceman.tr,
            ],
          onChanged: (value) {
              if(value == 0) {
                _viewModel.reviewsVisibilityHeight.value = 270 + _viewModel.reviewsByServiceman.length * 40;
              } else {
                _viewModel.reviewsVisibilityHeight.value = 270 + _viewModel.reviewsToServiceman.length * 40;
              }
          },
        ),
        Expanded(
          child: Obx(() => SizedBox(
                height: _viewModel.reviewsVisibilityHeight.value,
                child: TabBarView(
                  controller: _viewModel.reviewsTabController,
                    children: [
                      _ReviewsByServicemanList(),
                      _ReviewsToServicemanList(),
                    ]
                ),
              ),
          ),
        ),
      ],
    );
  }
}

/// Reviews given by servicemen list
class _ReviewsByServicemanList extends StatelessWidget {
  _ReviewsByServicemanList();

  final CustomerDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListBaseContainer(
      includeSearchField: false,
        expandFirstColumn: false,
        listData: _viewModel.reviewsByServiceman,
        columnsNames: [
          lang_key.sl.tr,
          lang_key.serviceman.tr,
          lang_key.rating.tr,
          lang_key.date.tr,
          lang_key.review.tr,
        ],
        onRefresh: () {}
    );
  }
}

/// Reviews given to servicemen list
class _ReviewsToServicemanList extends StatelessWidget {
  _ReviewsToServicemanList();

  final CustomerDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListBaseContainer(
      includeSearchField: false,
        expandFirstColumn: false,
        listData: _viewModel.reviewsToServiceman,
        columnsNames: [
          lang_key.sl.tr,
          lang_key.serviceman.tr,
          lang_key.rating.tr,
          lang_key.date.tr,
          lang_key.review.tr,
        ],
        onRefresh: () {}
    );
  }
}

/// Rating and Reviews section
class _RatingSection extends StatelessWidget {
  _RatingSection();

  final CustomerDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 15,
      children: [
        _RatingValueAndStars(),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: List.generate(5, (index) {

              int randomRatingValue = Random().nextInt(9);

              return Row(
                spacing: 15,
                children: [
                  Expanded(
                    flex: 5,
                      child: _RatingPercentageBar(
                        ratingValue: randomRatingValue,
                        index: index,
                      )
                  ),
                  Expanded(
                    child: Text(
                      _viewModel.ratingPercentageBarTexts[index],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        )
      ],
    );
  }
}

/// Rating value and stars
class _RatingValueAndStars extends StatelessWidget {
  _RatingValueAndStars();

  final CustomerDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            4.5.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 50
            ),
          ),
          RatingStars(
            iconSize: 15,
            initialRating: 4.5,
          )
        ],
      ),
    );
  }
}

/// Rating bar for showing percentage of a star's category
class _RatingPercentageBar extends StatelessWidget {
  const _RatingPercentageBar({required this.ratingValue, required this.index});

  final int index;
  final int ratingValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 15,
      child: Row(
        spacing: 15,
        children: [
          SizedBox(
            width: 8,
            child: Text(
              "${5 - index}",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                  borderRadius: kContainerBorderRadius,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        primaryBlue,
                        primaryBlue,
                        primaryGrey.withValues(alpha: 0.6),
                        primaryGrey.withValues(alpha: 0.6)
                      ],
                      stops: [
                        0.0,
                        ratingValue / 10,
                        ratingValue / 10,
                        1.0
                      ]
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Top heading at every section of details
class _ContainerInsideHeadingTextAndIcon extends StatelessWidget {
  const _ContainerInsideHeadingTextAndIcon({required this.text, this.iconImage});

  final String text;
  final String? iconImage;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Image.asset(iconImage ?? ImagesPaths.userDetailsSectionHeading, width: 25, height: 25,),
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
