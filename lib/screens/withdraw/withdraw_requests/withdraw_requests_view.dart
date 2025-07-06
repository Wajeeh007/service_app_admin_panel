import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/screens/withdraw/withdraw_requests/withdraw_requests_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
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
                  ListBaseContainer(
                    onSearch: (value) {},
                      onRefresh: () {},
                      controller: _viewModel.pendingWithdrawsSearchController,
                      listData: [].obs,
                      columnsNames: []
                  ),
                  ListBaseContainer(
                      onSearch: (value) {},
                      onRefresh: () {},
                      controller: _viewModel.approvedWithdrawsSearchController,
                      listData: [].obs,
                      columnsNames: []
                  ),
                  ListBaseContainer(
                      onSearch: (value) {},
                      onRefresh: () {},
                      controller: _viewModel.settledWithdrawSearchController,
                      listData: [].obs,
                      columnsNames: []
                  ),
                  ListBaseContainer(
                      onSearch: (value) {},
                      onRefresh: () {},
                      controller: _viewModel.deniedWithdrawSearchController,
                      listData: [].obs,
                      columnsNames: []
                  ),
            
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
                lang_key.date.tr,
                lang_key.status.tr,
                lang_key.actions.tr,
              ],
            entryChildren: List.generate(_viewModel.visibleAllRequestsList.length, (index) {
              return Padding(
                padding: listEntryPadding,
                child: Row(
                  children: [
                    ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
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
                          CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {},
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
                          CustomMaterialButton(
                            width: 20,
                            height: 20,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {},
                            buttonColor: primaryWhite,
                            borderColor: errorRed,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: errorRed,
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
                maxWidth: 100,
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