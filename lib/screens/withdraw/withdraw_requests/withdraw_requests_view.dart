import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/withdraw/withdraw_requests/withdraw_requests_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

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
                    includeSearchField: false,
                      listData: [].obs,
                      columnsNames: []
                  ),
                  ListBaseContainer(
                    includeSearchField: false,
                      listData: [].obs,
                      columnsNames: []
                  ),
                  ListBaseContainer(
                    includeSearchField: false,
                      listData: [].obs,
                      columnsNames: []
                  ),
                  ListBaseContainer(
                    includeSearchField: false,
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
        ListBaseContainer(
            controller: _viewModel.allWithdrawsSearchController,
            formKey: _viewModel.allWithdrawsFormKey,
            listData: _viewModel.allOrdersList,
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
            ]
        ),
      ],
    );
  }
}
