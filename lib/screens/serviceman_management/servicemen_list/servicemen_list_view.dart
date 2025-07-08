import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/servicemen_list/servicemen_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';

import '../../../utils/constants.dart';
import '../../../utils/custom_widgets/contact_info_in_list.dart';
import '../../../utils/custom_widgets/custom_tab_bar.dart';
import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/custom_widgets/list_serial_no_text.dart';
import '../../../utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../utils/custom_widgets/section_heading_text.dart';
import '../../../utils/custom_widgets/stats_container.dart';
import '../../../utils/custom_widgets/user_status.dart';

class ServiceMenListView extends StatelessWidget {
  ServiceMenListView({super.key});

  final ServiceMenListViewModel _viewModel = Get.put(ServiceMenListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.servicemenList.tr,
        overlayPortalControllersAndShowDropDown: [],
        children: [
          _ServicemenAnalyticsData(),
          SectionHeadingText(headingText: lang_key.servicemenList.tr),
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: [
                lang_key.all.tr,
                lang_key.active.tr,
              ]
          ),
          SizedBox(
            height: 800,
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _viewModel.tabController,
                children: [
                  _AllServicemenListTabView(),
                  _ActiveServicemenListTabView(),
                  // _InActiveServicemenListTabView(),
                ]
            ),
          )
        ],
    );
  }
}

/// Customer Analytics data
class _ServicemenAnalyticsData extends StatelessWidget {
  _ServicemenAnalyticsData();

  final ServiceMenListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeadingText(headingText: lang_key.servicemenAnalyticalData.tr),
        Obx(() => Row(
            spacing: 15,
            children: [
              StatsContainer(
                height: 200,
                statValue: _viewModel.serviceMenAnalyticalData.value.total ?? 0,
                statName: lang_key.totalServicemen.tr,
                iconContainerColor: Colors.purpleAccent,
                iconData: Icons.group,
              ),
              StatsContainer(
                height: 200,
                statValue: _viewModel.serviceMenAnalyticalData.value.active ?? 0,
                statName: lang_key.activeServicemen.tr,
                iconData: Icons.local_activity,
                iconContainerColor: Colors.green,
              ),
              StatsContainer(
                height: 200,
                statValue: _viewModel.serviceMenAnalyticalData.value.inActive ?? 0,
                statName: lang_key.suspendedServicemen.tr,
                iconData: Icons.block,
                iconContainerColor: errorRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// All Customers list tab view
class _AllServicemenListTabView extends StatelessWidget {
  _AllServicemenListTabView();

  final ServiceMenListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
            onSearch: (value) => _viewModel.searchList(value, _viewModel.allServiceMenList, _viewModel.visibleAllServiceMenList),
              onRefresh: () => _viewModel.fetchServicemenLists(),
              controller: _viewModel.allServiceMansSearchController,
              listData: _viewModel.visibleAllServiceMenList,
              expandFirstColumn: false,
              hintText: lang_key.searchServiceman.tr,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.totalOrders.tr,
                lang_key.earning.tr,
                lang_key.status.tr,
                lang_key.actions.tr
              ],
            entryChildren: List.generate(_viewModel.visibleAllServiceMenList.length, (index) {
              return Padding(
                padding: listEntryPadding.copyWith(bottom: 10),
                child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.visibleAllServiceMenList[index].name!),
                    ContactInfoInList(email: _viewModel.visibleAllServiceMenList[index].email!, phoneNo: _viewModel.visibleAllServiceMenList[index].phoneNo!,),
                    ListEntryItem(text: _viewModel.visibleAllServiceMenList[index].totalOrders.toString()),
                    ListEntryItem(text: _viewModel.visibleAllServiceMenList[index].earnings.toString()),
                    UserStatus(status: _viewModel.visibleAllServiceMenList[index].status!),
                    ListEntryItem(
                      child: ListActionsButtons(
                          includeDelete: _viewModel.visibleAllServiceMenList[index].status!,
                          includeEdit: false,
                          includeView: true,
                        onViewPressed: () {},
                        deleteIcon: _viewModel.visibleAllServiceMenList[index].status! ? CupertinoIcons.nosign : null,
                        onDeletePressed: _viewModel.visibleAllServiceMenList[index].status! ? () => showConfirmationDialog(onPressed: () {}, message: lang_key.suspensionConfirmationMessage.tr) : null,
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

/// Active customers list tab view
class _ActiveServicemenListTabView extends StatelessWidget {
  _ActiveServicemenListTabView();

  final ServiceMenListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
              onSearch: (value) => _viewModel.searchList(value, _viewModel.allActiveServiceMenList, _viewModel.visibleActiveServicemenList),
              onRefresh: () => _viewModel.fetchServicemenWithStatus(true),
              controller: _viewModel.activeServiceMansSearchController,
              listData: _viewModel.visibleActiveServicemenList,
              expandFirstColumn: false,
              hintText: lang_key.searchServiceman.tr,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.gender.tr,
                lang_key.totalOrders.tr,
                lang_key.earning.tr,
                lang_key.actions.tr
              ],
            entryChildren: List.generate(_viewModel.visibleActiveServicemenList.length, (index) {
              return Padding(
                padding: listEntryPadding,
                child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.visibleActiveServicemenList[index].name!),
                    ContactInfoInList(email: _viewModel.visibleActiveServicemenList[index].email!, phoneNo: _viewModel.visibleActiveServicemenList[index].phoneNo!,),
                    ListEntryItem(text: switch(_viewModel.visibleActiveServicemenList[index].gender!) {

                      Gender.male => lang_key.male.tr,
                      Gender.female => lang_key.female.tr,
                      Gender.other => lang_key.other.tr,
                    },),
                    ListEntryItem(text: _viewModel.visibleActiveServicemenList[index].totalOrders.toString()),
                    ListEntryItem(text: _viewModel.visibleActiveServicemenList[index].earnings.toString()),
                    ListEntryItem(
                      child: ListActionsButtons(
                        includeDelete: true,
                        includeEdit: false,
                        includeView: true,
                        onViewPressed: () {},
                        deleteIcon: CupertinoIcons.nosign,
                        onDeletePressed: () => showConfirmationDialog(onPressed: () {}, message: lang_key.suspensionConfirmationMessage.tr),
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

/// Inactive customers list tab view
class _InActiveServicemenListTabView extends StatelessWidget {
  _InActiveServicemenListTabView();

  final ServiceMenListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
              onSearch: (value) => _viewModel.searchList(value, _viewModel.allInActiveServiceMenList, _viewModel.visibleInActiveServicemenList),
              onRefresh: () => _viewModel.fetchServicemenWithStatus(false),
              controller: _viewModel.inActiveServiceMansSearchController,
              listData: _viewModel.visibleInActiveServicemenList,
              expandFirstColumn: false,
              hintText: lang_key.searchServiceman.tr,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.gender.tr,
                lang_key.totalOrders.tr,
                lang_key.earning.tr,
                lang_key.actions.tr
              ],
          entryChildren: List.generate(_viewModel.visibleInActiveServicemenList.length, (index) {
            return Padding(
              padding: listEntryPadding,
              child: Row(
                children: [
                  ListSerialNoText(index: index),
                  ListEntryItem(text: _viewModel.visibleInActiveServicemenList[index].name!),
                  ContactInfoInList(email: _viewModel.visibleInActiveServicemenList[index].email!, phoneNo: _viewModel.visibleInActiveServicemenList[index].phoneNo!,),
                  ListEntryItem(text: switch(_viewModel.visibleInActiveServicemenList[index].gender!) {

                    Gender.male => lang_key.male.tr,
                    Gender.female => lang_key.female.tr,
                    Gender.other => lang_key.other.tr,
                  },),
                  ListEntryItem(text: _viewModel.visibleInActiveServicemenList[index].totalOrders.toString()),
                  ListEntryItem(text: _viewModel.visibleInActiveServicemenList[index].earnings.toString()),
                  ListEntryItem(
                    child: ListActionsButtons(
                      includeDelete: true,
                      includeEdit: false,
                      includeView: true,
                      onViewPressed: () {},
                      deleteIcon: CupertinoIcons.nosign,
                      onDeletePressed: () => showConfirmationDialog(onPressed: () {}, message: lang_key.suspensionConfirmationMessage.tr),
                    ),
                  )
                ],
              ),
            );
          }),
        )),
      ],
    );
  }
}