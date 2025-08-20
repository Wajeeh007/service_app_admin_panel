
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/helpers/determine_list_height.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/serviceman_details/serviceman_details_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_cached_network_image.dart';
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

class ServicemanDetailsView extends StatelessWidget {
  ServicemanDetailsView({super.key});

  final ServicemanDetailsViewModel _viewModel = Get.put(ServicemanDetailsViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: _viewModel.sidePanelItem.value,
        children: [
          Obx(() => SectionHeadingText(headingText: "${lang_key.serviceman.tr}_${_viewModel.servicemanDetails.value.id}")),
          _ServicemanInfoAndActivity(),
          _ServicemanWallet(),
          CustomTabBar(
              controller: _viewModel.mainTabController,
              onChanged: (value) {
                switch(value) {
                  case 0: GlobalVariables.listHeight.value = 200;
                  case 1: listSize(length: _viewModel.visibleServicemanOrders.length);
                  case 2: listSize(length: _viewModel.transactions.length );
                  case 3: listSize(length: _viewModel.servicemanDetails.value.services != null ? _viewModel.servicemanDetails.value.services!.length : 0);
                  case 4: GlobalVariables.listHeight.value = 600 + (_viewModel.reviewsTabController.index == 0 ? _viewModel.reviewsByServiceman.length * 40 : _viewModel.reviewsToCustomer.length * 40);
                }
              },
              tabsNames: [
                lang_key.overView.tr,
                lang_key.orders.tr,
                lang_key.services.tr,
                lang_key.transactions.tr,
                lang_key.reviews.tr,
              ]
          ),
          Obx(() => SizedBox(
              height: GlobalVariables.listHeight.value,
              child: TabBarView(
                controller: _viewModel.mainTabController,
                  children: [
                    _ServicemanOverviewTab(),
                    _ServicemanOrdersTab(),
                    _ServicemanServicesTab(),
                    _ServicemanTransactionsTab(),
                    _ServicemanReviewsTab(),
                  ]
              ),
            ),
          ),
          Obx(() => Visibility(
              visible: _viewModel.servicemanDetails.value.status == UserStatuses.suspended || _viewModel.servicemanDetails.value.status == UserStatuses.active,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: _viewModel.servicemanDetails.value.status == UserStatuses.suspended || _viewModel.servicemanDetails.value.status == UserStatuses.pending,
                      child: CustomMaterialButton(
                        borderColor: CupertinoColors.activeGreen,
                        buttonColor: CupertinoColors.activeGreen,
                        width: 150,
                        text: lang_key.activate.tr,
                          onPressed: () => _viewModel.updateUserStatus(UserStatuses.active),
                      ),
                    ),
                    Visibility(
                      visible: _viewModel.servicemanDetails.value.status == UserStatuses.active || _viewModel.servicemanDetails.value.status == UserStatuses.pending,
                      child: CustomMaterialButton(
                        borderColor: errorRed,
                        buttonColor: errorRed,
                        width: 150,
                        text: lang_key.suspend.tr,
                        onPressed: () => _viewModel.updateUserStatus(_viewModel.servicemanDetails.value.status == UserStatuses.pending ? UserStatuses.declined : UserStatuses.suspended),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Customer information and activity rate section
class _ServicemanInfoAndActivity extends StatelessWidget {
  const _ServicemanInfoAndActivity();

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.sizeOf(context).width >= 1300 ? 250 : 360,
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: kContainerBoxDecoration,
      child: Row(
        children: [
          _CustomerInfoSection(),
          _ServicemanActivitySection(),
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
          _ContainerInsideHeadingTextAndIcon(text: lang_key.servicemanInfo.tr),
          _ServicemanBasicInfo(),
        ],
      ),
    );
  }
}

/// Customer activity section and rates of activities performed.
class _ServicemanActivitySection extends StatelessWidget {
  const _ServicemanActivitySection();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ContainerInsideHeadingTextAndIcon(text: lang_key.servicemanActivityRate.tr),
          Expanded(
            child: Column(
              crossAxisAlignment: MediaQuery.sizeOf(context).width >= 1300 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              spacing: 15,
              children: [
                _ServicemanActivityRateBar(),
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
class _ServicemanActivityRateBar extends StatelessWidget {
  _ServicemanActivityRateBar();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {

    return Obx(() => Row(
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
                        _viewModel.activityStats['average_activity_rate'] == null ? 0.0 : _viewModel.activityStats['average_activity_rate'] / 100 ?? 0.0,
                        _viewModel.activityStats['average_activity_rate'] == null ? 0.0 : _viewModel.activityStats['average_activity_rate'] / 100 ?? 0.0,
                        1
                      ]
                  )
              ),
            ),
          ),
          Text("${_viewModel.activityStats['average_activity_rate'] ?? 0}%", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryBlue))
        ],
      ),
    );
  }
}

/// Serviceman image, name, phone, rating and email
class _ServicemanBasicInfo extends StatelessWidget {
  _ServicemanBasicInfo();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: MediaQuery.sizeOf(context).width >= 1300 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Obx(() => ClipRRect(
              borderRadius: kContainerBorderRadius,
              child: CustomNetworkImage(imageUrl: _viewModel.servicemanDetails.value.profileImage ?? '', height: MediaQuery.sizeOf(context).width * 0.1, width: MediaQuery.sizeOf(context).width * 0.1,),
            ),
          ),
          Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MediaQuery.sizeOf(context).width >= 1300 ? MainAxisAlignment.center : MainAxisAlignment.start,
              spacing: 5,
              children: [
                Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_viewModel.servicemanDetails.value.name ?? '', style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,

                      )),
                      RatingAndValue(ratingValue: _viewModel.servicemanDetails.value.rating ?? 0.0)
                    ],
                  ),
                Text(
                  _viewModel.servicemanDetails.value.phoneNo ?? '',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                      letterSpacing: 0.4
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.15,
                  child: Text(
                    _viewModel.servicemanDetails.value.email ?? '',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey,
                        letterSpacing: 0.4
                    ),
                    maxLines: 2,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Serviceman Wallet section
class _ServicemanWallet extends StatelessWidget {
  _ServicemanWallet();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryWhite,
      padding: EdgeInsets.all(15),
      constraints: BoxConstraints(
        maxHeight: 280,
        minWidth: double.infinity,
        maxWidth: double.infinity
      ),
      child: Column(
        spacing: 8,
        children: [
          _ContainerInsideHeadingTextAndIcon(text: lang_key.walletInfo.tr),
          Expanded(
            child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 10,
                children: [
                  _WalletStatWidget(icon: CupertinoIcons.money_dollar_circle, value: _viewModel.servicemanDetails.value.totalEarning ?? 0.0, text: lang_key.totalEarnings.tr,),
                  _WalletStatWidget(icon: Icons.local_atm_rounded, value: _viewModel.servicemanDetails.value.withdrawableAmount ?? 0.0, text: lang_key.withdrawableAmount.tr,),
                  _WalletStatWidget(icon: Icons.money_off_rounded, value: _viewModel.servicemanDetails.value.withdrawnAmount ?? 0.0, text: lang_key.withdrawnAmount.tr,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Serviceman Wallet single stat widget
class _WalletStatWidget extends StatelessWidget {
  const _WalletStatWidget({
    required this.icon,
    required this.value,
    required this.text,
});

  final IconData icon;
  final double value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.sizeOf(context).width > 1250 ? 250 : MediaQuery.sizeOf(context).width * 0.15,
        // maxWidth: MediaQuery.sizeOf(context).width > 1250 ? 250 : MediaQuery.sizeOf(context).width * 0.15,
        maxHeight: 180,
        minHeight: 180
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: kContainerBorderRadius,
        boxShadow: [
          BoxShadow(
            color: primaryGrey,
            blurRadius: 10,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
            color: primaryBlue,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Serviceman Order details container
class _ServicemanOverviewTab extends StatelessWidget {
  _ServicemanOverviewTab();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width * 0.35,
                minHeight: 200,
                maxHeight: 200,
                maxWidth: MediaQuery.sizeOf(context).width * 0.35,
              ),
              decoration: kContainerBoxDecoration,
              child: Column(
                spacing: 20,
                children: [
                  _ContainerInsideHeadingTextAndIcon(text: lang_key.servicemanOrderDetails.tr),
                  Obx(() => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 10,
                      children: [
                        _OrderStatisticsTextAndValue(text: lang_key.totalCompletedOrders.tr, value: _viewModel.activityStats['total_completed_orders'] ?? 0),
                        _OrderStatisticsTextAndValue(text: lang_key.totalCancelledOrders.tr, value: _viewModel.activityStats['total_cancelled_orders'] ?? 0),
                        _OrderStatisticsTextAndValue(text: lang_key.highestAmountOrder.tr, value: "\$${_viewModel.activityStats['highest_amount_order'] ?? 0.0}"),
                        _OrderStatisticsTextAndValue(text: lang_key.lowestAmountOrder.tr, value: "\$${_viewModel.activityStats['lowest_amount_order'] ?? 0.0}"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width * 0.35,
                minHeight: 200,
                maxHeight: 200,
                maxWidth: MediaQuery.sizeOf(context).width * 0.35,
              ),
              decoration: kContainerBoxDecoration,
              child: Column(
                spacing: 20,
                children: [
                  _ContainerInsideHeadingTextAndIcon(text: lang_key.servicemanDocs.tr),
                  Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      _ServicemanDoc(text: lang_key.idCardFront.tr, value: _viewModel.servicemanDetails.value.idCardFront),
                      _ServicemanDoc(text: lang_key.idCardBack.tr, value: _viewModel.servicemanDetails.value.idCardBack),
                      _ServicemanDoc(text: lang_key.selfie.tr, value: ""),
                    ],
                  ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Serviceman Orders tab
class _ServicemanOrdersTab extends StatelessWidget {
  _ServicemanOrdersTab();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onRefresh: () => _viewModel.fetchServicemanOrders(),
          onSearch: (value) {},
          expandFirstColumn: false,
          hintText: lang_key.searchOrder.tr,
          controller: _viewModel.ordersSearchController,
          listData: _viewModel.visibleServicemanOrders,
          columnsNames: [
            lang_key.sl.tr,
            lang_key.date.tr,
            lang_key.totalAmount.tr,
            lang_key.commission.tr,
            lang_key.paymentStatus.tr,
            lang_key.orderStatus.tr,
            lang_key.actions.tr
          ],
          entryChildren: List.generate(_viewModel.visibleServicemanOrders.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleServicemanOrders[index].orderDateTime!),),
                  ListEntryItem(text: _viewModel.visibleServicemanOrders[index].totalAmount.toString(),),
                  ListEntryItem(text: _viewModel.visibleServicemanOrders[index].commissionAmount.toString(),),
                  TwoStatesWidget(status: _viewModel.visibleServicemanOrders[index].paymentStatus!, trueStateText: lang_key.paid.tr, falseStateText: lang_key.unpaid.tr,),
                  OrderStatusWidget(orderStatus: _viewModel.visibleServicemanOrders[index].status!),
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

/// Serviceman Services
class _ServicemanServicesTab extends StatelessWidget {
  _ServicemanServicesTab();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onRefresh: () => _viewModel.fetchServiceman(),
          includeSearchField: false,
          expandFirstColumn: false,
          listData: _viewModel.servicemanServices,
          columnsNames: [
            lang_key.sl.tr,
            lang_key.name.tr,
            lang_key.additionDate.tr,
            lang_key.subService.tr,
          ],
          entryChildren: List.generate(_viewModel.servicemanServices.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.servicemanServices[index].name!),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.servicemanServices[index].createdAt!),),
                  ListEntryItem(text: _viewModel.servicemanServices[index].subService!.name!,),
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

/// Serviceman Transactions Tab
class _ServicemanTransactionsTab extends StatelessWidget {
  _ServicemanTransactionsTab();

  final ServicemanDetailsViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListBaseContainer(
          onRefresh: () => _viewModel.fetchServicemanTransactions(),
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
      entryChildren: List.generate(_viewModel.transactions.length, (index) {
        return Padding(
          padding: listEntryPadding,
          child: Row(
            children: [
              ListSerialNoText(index: index),
              ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.transactions[index].transactionDate!)),
              ListEntryItem(text: _viewModel.transactions[index].totalAmount.toString(),),
              ListEntryItem(text: _viewModel.transactions[index].commission.toString(),),
              TwoStatesWidget(status: _viewModel.transactions[index].paymentStatus == TransactionPaymentStatus.paid, trueStateText: lang_key.paid.tr, falseStateText: lang_key.unpaid.tr,),
            ],
          ),
        );
      }),
      ),
    );
  }
}

/// Serviceman Reviews Tab
class _ServicemanReviewsTab extends StatelessWidget {
  _ServicemanReviewsTab();

  final ServicemanDetailsViewModel _viewModel = Get.find();

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
                _viewModel.reviewsVisibilityHeight.value = 270 + _viewModel.reviewsToCustomer.length * 40;
              }
          },
        ),
        Expanded(
          child: Obx(() => SizedBox(
                height: _viewModel.reviewsVisibilityHeight.value,
                child: TabBarView(
                  controller: _viewModel.reviewsTabController,
                    children: [
                      _ReviewsByCustomerList(),
                      _ReviewsToCustomerList(),
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
class _ReviewsByCustomerList extends StatelessWidget {
  _ReviewsByCustomerList();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListBaseContainer(
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
          onRefresh: () => _viewModel.fetchReviews(false),
        entryChildren: List.generate(_viewModel.reviewsByServiceman.length, (index) {
          return Padding(
            padding: listEntryPadding,
            child: Row(
              children: [
                ListSerialNoText(index: index),
                ListEntryItem(text: _viewModel.reviewsByServiceman[index].servicemanName ?? '',),
                ListEntryItem(text: _viewModel.reviewsByServiceman[index].ratingByServiceman.toString()),
                ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.reviewsByServiceman[index].servicemanReviewDate!)),
                ListEntryItem(text: _viewModel.reviewsByServiceman[index].servicemanRemarks),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Reviews given to servicemen list
class _ReviewsToCustomerList extends StatelessWidget {
  _ReviewsToCustomerList();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListBaseContainer(
        includeSearchField: false,
          expandFirstColumn: false,
          listData: _viewModel.reviewsToCustomer,
          columnsNames: [
            lang_key.sl.tr,
            lang_key.serviceman.tr,
            lang_key.rating.tr,
            lang_key.date.tr,
            lang_key.review.tr,
          ],
          onRefresh: () => _viewModel.fetchReviews(true),
          entryChildren: List.generate(_viewModel.reviewsToCustomer.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.reviewsToCustomer[index].servicemanName ?? '',),
                  ListEntryItem(text: _viewModel.reviewsToCustomer[index].ratingByServiceman.toString()),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.reviewsToCustomer[index].servicemanReviewDate!)),
                  ListEntryItem(text: _viewModel.reviewsToCustomer[index].servicemanRemarks),
                ],
              ),
            );
          })
      ),
    );
  }
}

/// Rating and Reviews section
class _RatingSection extends StatelessWidget {
  _RatingSection();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 15,
      children: [
        _RatingValueAndStars(),
        Expanded(
          flex: 6,
          child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: List.generate(5, (index) {

                return Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      flex: 5,
                        child: _RatingPercentageBar(
                          ratingValue: switch(index) {
                            0 => _viewModel.reviewStats.value.fiveStar ?? 0.0,
                            1 => _viewModel.reviewStats.value.fourStar ?? 0.0,
                            2 => _viewModel.reviewStats.value.threeStar ?? 0.0,
                            3 => _viewModel.reviewStats.value.twoStar ?? 0.0,
                            4 => _viewModel.reviewStats.value.oneStar ?? 0.0,
                            int() => 0.0,
                          },
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
          ),
        )
      ],
    );
  }
}

/// Rating value and stars
class _RatingValueAndStars extends StatelessWidget {
  _RatingValueAndStars();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _viewModel.servicemanDetails.value.rating == null ? 0.0.toString() : _viewModel.servicemanDetails.value.rating.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 50
            ),
          ),
          RatingStars(
            iconSize: 15,
            initialRating: _viewModel.servicemanDetails.value.rating ?? 0.0,
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
  final double ratingValue;

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
                        ratingValue,
                        ratingValue,
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

/// Mathematical rate stats of the serviceman
class _RatesSection extends StatelessWidget {
  _RatesSection();

  final ServicemanDetailsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
        spacing: 15,
        children: [
          _SingleRateContainer(value: _viewModel.activityStats['average_spending_value'] ?? 0, figureText: lang_key.averageSpending.tr, figureUnit: '\$',),
          _SingleRateContainer(value: _viewModel.activityStats['positive_review_rate'] ?? 0, figureText: lang_key.positiveReviewRate.tr, color: Colors.orange,),
          _SingleRateContainer(value: _viewModel.activityStats['success_rate'] ?? 0, figureText: lang_key.successRate.tr, color: Colors.green,),
          _SingleRateContainer(value: _viewModel.activityStats['cancellation_rate'] ?? 0, figureText: lang_key.cancellationRate.tr, color: Colors.redAccent,),
        ],
      ),
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

  final num value;
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
  final dynamic value;
  
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
          value.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: primaryGrey
          ),
        )
      ],
    );
  }
}

/// Serviceman Document widget
class _ServicemanDoc extends StatelessWidget {
  const _ServicemanDoc({required this.text, required this.value});

  final String text;
  final String? value;

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
        if(value != null) InkWell(
          onTap: () {},
            child: CircleAvatar(
              backgroundColor: primaryBlue,
              radius: 10,
              child: Icon(
                CupertinoIcons.down_arrow,
                color: Colors.white,
                size: 15,
              ),
            ),
          )
      ],
    );
  }
}