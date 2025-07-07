import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/screens/withdraw/withdraw_requests/withdraw_requests_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_serial_no_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../utils/custom_widgets/custom_material_button.dart';

class WithdrawRequestsView extends StatelessWidget {
  WithdrawRequestsView({super.key});

  final WithdrawRequestsViewModel _viewModel = Get.put(WithdrawRequestsViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.requests.tr,
        children: [
          SectionHeadingText(headingText: lang_key.requests.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: [
                lang_key.all.tr,
                lang_key.pending.tr,
                lang_key.approved.tr,
                lang_key.settled.tr,
                lang_key.denied.tr,
              ]
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _viewModel.tabController,
                children: [
                  _AllWithdrawRequests(),
                  _PendingWithdrawRequestsTab(),
                  _ApprovedWithdrawRequestsTab(),
                  _SettledWithdrawRequestsTab(),
                  _DeniedWithdrawRequestsTab(),
                ]
            ),
          )
        ]
    );
  }
}

/// All withdraw requests list
class _AllWithdrawRequests extends StatelessWidget {
  _AllWithdrawRequests();

  final WithdrawRequestsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
            onSearch: (value) => _viewModel.searchList(value, _viewModel.allRequestsList, _viewModel.visibleAllRequestsList),
              onRefresh: () => _viewModel.fetchWithdrawRequests(),
              controller: _viewModel.allWithdrawsSearchController,
              listData: _viewModel.visibleAllRequestsList,
              expandFirstColumn: false,
              hintText: lang_key.searchByServiceman.tr,
              fieldWidth: 210,
              columnsNames: [
                'SL',
                lang_key.name.tr,
                lang_key.amount.tr,
                lang_key.method.tr,
                lang_key.requestDate.tr,
                lang_key.status.tr,
                lang_key.actions.tr,
              ],
            entryChildren: List.generate(_viewModel.visibleAllRequestsList.length, (index) {
              return Padding(
                padding: listEntryPadding,
                child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.visibleAllRequestsList[index].servicemanName!),
                    ListEntryItem(text: _viewModel.visibleAllRequestsList[index].amount.toString()),
                    ListEntryItem(text: _viewModel.visibleAllRequestsList[index].withdrawMethodName),
                    ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleAllRequestsList[index].createdAt!)),
                    StatusWidget(status: _viewModel.visibleAllRequestsList[index].status!),
                    ListEntryItem(
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(_viewModel.visibleAllRequestsList[index].status! != WithdrawRequestStatus.denied) Tooltip(
                            message: _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending ? lang_key.approve.tr : _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.approved ? lang_key.settle.tr : null,
                            child: CustomMaterialButton(
                              width: 20,
                              height: 20,
                              borderRadius: BorderRadius.circular(8),
                              onPressed: () => _viewModel.visibleAllRequestsList[index].status! == WithdrawRequestStatus.pending ? _viewModel.approveRequest(_viewModel.visibleAllRequestsList[index]) : _viewModel.showSettleRequestDialog(_viewModel.visibleAllRequestsList[index]),
                              buttonColor: primaryWhite,
                              borderColor: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending ? Icons.approval_rounded : Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Tooltip(
                            message: _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending || _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.approved ? lang_key.decline.tr : lang_key.view.tr,
                            child: CustomMaterialButton(
                              width: 20,
                              height: 20,
                              borderRadius: BorderRadius.circular(8),
                              onPressed: () => _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending || _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.approved ? _viewModel.dialogToDeclineWithdrawRequest(_viewModel.visibleAllRequestsList[index]) : null,
                              buttonColor: primaryWhite,
                              borderColor: _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending || _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.approved ? errorRed : primaryBlue,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending || _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.approved ? Icons.remove_circle_rounded : Icons.visibility,
                                  color: _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.pending || _viewModel.visibleAllRequestsList[index].status == WithdrawRequestStatus.approved ? errorRed : primaryBlue,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
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

/// Pending Withdraw requests tab
class _PendingWithdrawRequestsTab extends StatelessWidget {
  _PendingWithdrawRequestsTab();

  final WithdrawRequestsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onSearch: (value) => _viewModel.searchList(value, _viewModel.allPendingRequestsList, _viewModel.visiblePendingRequestsList),
          onRefresh: () {},
          controller: _viewModel.pendingWithdrawsSearchController,
          listData: _viewModel.visiblePendingRequestsList,
          expandFirstColumn: false,
          hintText: lang_key.searchByServiceman.tr,
          fieldWidth: 210,
          columnsNames: [
            'SL',
            lang_key.name.tr,
            lang_key.amount.tr,
            lang_key.method.tr,
            lang_key.requestDate.tr,
            lang_key.accountId.tr,
            lang_key.actions.tr,
          ],
          entryChildren: List.generate(_viewModel.visiblePendingRequestsList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.visiblePendingRequestsList[index].servicemanName!),
                  ListEntryItem(text: _viewModel.visiblePendingRequestsList[index].amount.toString()),
                  ListEntryItem(text: _viewModel.visiblePendingRequestsList[index].withdrawMethodName),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visiblePendingRequestsList[index].createdAt!)),
                  ListEntryItem(text: _viewModel.visiblePendingRequestsList[index].servicemanAccountId!),
                  ListEntryItem(
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: lang_key.approve.tr,
                          child: CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {},
                            buttonColor: primaryWhite,
                            borderColor: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.approval_rounded,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: lang_key.decline.tr,
                          child: CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {},
                            buttonColor: primaryWhite,
                            borderColor: errorRed,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.remove_circle_rounded,
                                color: errorRed,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
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

/// Approved Withdraw requests tab
class _ApprovedWithdrawRequestsTab extends StatelessWidget {
  _ApprovedWithdrawRequestsTab();

  final WithdrawRequestsViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onSearch: (value) => _viewModel.searchList(value, _viewModel.allApprovedRequestsList, _viewModel.visibleApprovedRequestsList),
          onRefresh: () {},
          controller: _viewModel.approvedWithdrawsSearchController,
          listData: _viewModel.visibleApprovedRequestsList,
          expandFirstColumn: false,
          hintText: lang_key.searchByServiceman.tr,
          fieldWidth: 210,
          columnsNames: [
            'SL',
            lang_key.name.tr,
            lang_key.amount.tr,
            lang_key.method.tr,
            lang_key.requestDate.tr,
            lang_key.accountId.tr,
            lang_key.actions.tr,
          ],
          entryChildren: List.generate(_viewModel.visibleApprovedRequestsList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.visibleApprovedRequestsList[index].servicemanName!),
                  ListEntryItem(text: _viewModel.visibleApprovedRequestsList[index].amount.toString()),
                  ListEntryItem(text: _viewModel.visibleApprovedRequestsList[index].withdrawMethodName),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleApprovedRequestsList[index].createdAt!)),
                  ListEntryItem(text: _viewModel.visibleApprovedRequestsList[index].servicemanAccountId!),
                  ListEntryItem(
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: lang_key.settle.tr,
                          child: CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () => _viewModel.showSettleRequestDialog(_viewModel.visibleApprovedRequestsList[index]),
                            buttonColor: primaryWhite,
                            borderColor: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: lang_key.decline.tr,
                          child: CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () => _viewModel.dialogToDeclineWithdrawRequest(_viewModel.visibleApprovedRequestsList[index]),
                            buttonColor: primaryWhite,
                            borderColor: errorRed,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.remove_circle_rounded,
                                color: errorRed,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
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

/// Settled Withdraw requests tab
class _SettledWithdrawRequestsTab extends StatelessWidget {
  _SettledWithdrawRequestsTab();

  final WithdrawRequestsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onSearch: (value) => _viewModel.searchList(value, _viewModel.allSettledRequestsList, _viewModel.visibleSettledRequestsList),
          onRefresh: () {},
          controller: _viewModel.settledWithdrawsSearchController,
          listData: _viewModel.visibleSettledRequestsList,
          expandFirstColumn: false,
          hintText: lang_key.searchByServiceman.tr,
          fieldWidth: 210,
          columnsNames: [
            'SL',
            lang_key.name.tr,
            lang_key.amount.tr,
            lang_key.method.tr,
            lang_key.transferDate.tr,
            lang_key.transactionId.tr,
            lang_key.actions.tr,
          ],
          entryChildren: List.generate(_viewModel.visibleSettledRequestsList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.visibleSettledRequestsList[index].servicemanName!),
                  ListEntryItem(text: _viewModel.visibleSettledRequestsList[index].amount.toString()),
                  ListEntryItem(text: _viewModel.visibleSettledRequestsList[index].withdrawMethodName),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleSettledRequestsList[index].transferDate!)),
                  ListEntryItem(text: _viewModel.visibleSettledRequestsList[index].transactionId!),
                  ListEntryItem(
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomMaterialButton(
                          width: 20,
                          height: 20,
                          borderRadius: BorderRadius.circular(8),
                          onPressed: () {},
                          buttonColor: primaryWhite,
                          borderColor: primaryBlue,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              CupertinoIcons.eye,
                              color: primaryBlue,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
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

/// Denied Withdraw requests tab
class _DeniedWithdrawRequestsTab extends StatelessWidget {
  _DeniedWithdrawRequestsTab();

  final WithdrawRequestsViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
          onSearch: (value) => _viewModel.searchList(value, _viewModel.allDeniedRequestsList, _viewModel.visibleDeniedRequestsList),
          onRefresh: () {},
          controller: _viewModel.deniedWithdrawsSearchController,
          listData: _viewModel.visibleDeniedRequestsList,
          expandFirstColumn: false,
          hintText: lang_key.searchByServiceman.tr,
          fieldWidth: 210,
          columnsNames: [
            'SL',
            lang_key.name.tr,
            lang_key.amount.tr,
            lang_key.method.tr,
            lang_key.requestDate.tr,
            lang_key.adminNote.tr,
            lang_key.actions.tr,
          ],
          entryChildren: List.generate(_viewModel.visibleDeniedRequestsList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.visibleDeniedRequestsList[index].servicemanName!),
                  ListEntryItem(text: _viewModel.visibleDeniedRequestsList[index].amount.toString()),
                  ListEntryItem(text: _viewModel.visibleDeniedRequestsList[index].withdrawMethodName),
                  ListEntryItem(text: DateFormat('dd/MM/yyyy').format(_viewModel.visibleDeniedRequestsList[index].createdAt!)),
                  ListEntryItem(text: _viewModel.visibleDeniedRequestsList[index].note!, maxLines: 3,),
                  ListEntryItem(
                    child: Tooltip(
                      message: lang_key.view.tr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {},
                            buttonColor: primaryWhite,
                            borderColor: primaryBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                CupertinoIcons.eye,
                                color: primaryBlue,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
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

/// Withdraw requests status widget
class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.status});

  final WithdrawRequestStatus status;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: 110,
                maxHeight: 40
            ),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    color: switch(status) {
                      WithdrawRequestStatus.pending => Colors.orange,
                      WithdrawRequestStatus.approved => primaryBlue,
                      WithdrawRequestStatus.settled => Colors.green,
                      WithdrawRequestStatus.denied => Colors.red,
                    },
                    width: 1
                ),
                borderRadius: kContainerBorderRadius
            ),
            child: Text(
              switch(status) {
                WithdrawRequestStatus.pending => "• ${lang_key.pending.tr}",
                WithdrawRequestStatus.approved => "• ${lang_key.approved.tr}",
                WithdrawRequestStatus.settled => "• ${lang_key.settled.tr}",
                WithdrawRequestStatus.denied => "• ${lang_key.denied.tr}"
              },
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: switch(status) {
                  WithdrawRequestStatus.pending => Colors.orange,
                  WithdrawRequestStatus.approved => primaryBlue,
                  WithdrawRequestStatus.settled => Colors.green,
                  WithdrawRequestStatus.denied => Colors.red,
                },
              ),
            )
        ),
      ),
    );
  }
}