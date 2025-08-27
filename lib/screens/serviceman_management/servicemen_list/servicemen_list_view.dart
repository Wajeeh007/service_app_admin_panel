import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/servicemen_list/servicemen_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_actions_buttons.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_entry_item.dart';
import 'package:service_app_admin_panel/utils/routes.dart';

import '../../../utils/constants.dart';
import '../../../utils/custom_widgets/contact_info_in_list.dart';
import '../../../utils/custom_widgets/list_base_container.dart';
import '../../../utils/custom_widgets/list_serial_no_text.dart';
import '../../../utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../utils/custom_widgets/section_heading_text.dart';
import '../../../utils/custom_widgets/stats_container.dart';

class ServiceMenListView extends StatelessWidget {
  ServiceMenListView({super.key});

  final ServicemenListViewModel _viewModel = Get.put(ServicemenListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.servicemenList.tr,
        overlayPortalControllersAndShowDropDown: [],
        children: [
          _ServicemenAnalyticsData(),
          SectionHeadingText(headingText: lang_key.servicemenList.tr),
          // CustomTabBar(
          //     controller: _viewModel.tabController,
          //     tabsNames: [
          //       lang_key.all.tr,
          //       lang_key.active.tr,
          //     ]
          // ),
          _AllServicemenListTabView(),
          // SizedBox(
          //   height: 800,
          //   child: TabBarView(
          //       physics: NeverScrollableScrollPhysics(),
          //       controller: _viewModel.tabController,
          //       children: [
          //
          //         // _InActiveServicemenListTabView(),
          //       ]
          //   ),
          // )
        ],
    );
  }
}

/// Customer Analytics data
class _ServicemenAnalyticsData extends StatelessWidget {
  _ServicemenAnalyticsData();

  final ServicemenListViewModel _viewModel = Get.find();

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
                statValue: _viewModel.servicemenAnalyticalData.value.total ?? 0,
                statName: lang_key.totalServicemen.tr,
                iconContainerColor: Colors.purpleAccent,
                iconData: Icons.group,
              ),
              StatsContainer(
                height: 200,
                statValue: _viewModel.servicemenAnalyticalData.value.active ?? 0,
                statName: lang_key.activeServicemen.tr,
                iconData: Icons.local_activity,
                iconContainerColor: Colors.green,
              ),
              StatsContainer(
                height: 200,
                statValue: _viewModel.servicemenAnalyticalData.value.inActive ?? 0,
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

  final ServicemenListViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListBaseContainer(
            onSearch: (value) => _viewModel.searchList(value, _viewModel.allServicemenList, _viewModel.visibleAllServicemenList),
              onRefresh: () => _viewModel.fetchServicemenLists(),
              controller: _viewModel.allServiceMansSearchController,
              listData: _viewModel.visibleAllServicemenList,
              expandFirstColumn: false,
              hintText: lang_key.searchServiceman.tr,
              columnsNames: [
                lang_key.sl.tr,
                lang_key.name.tr,
                lang_key.contactInfo.tr,
                lang_key.totalOrders.tr,
                lang_key.earning.tr,
                lang_key.gender.tr,
                lang_key.actions.tr
              ],
            entryChildren: List.generate(_viewModel.visibleAllServicemenList.length, (index) {
              return Padding(
                padding: listEntryPadding.copyWith(bottom: 10),
                child: Row(
                  children: [
                    ListSerialNoText(index: index),
                    ListEntryItem(text: _viewModel.visibleAllServicemenList[index].name!),
                    ContactInfoInList(email: _viewModel.visibleAllServicemenList[index].email!, phoneNo: _viewModel.visibleAllServicemenList[index].phoneNo!,),
                    ListEntryItem(text: _viewModel.visibleAllServicemenList[index].totalOrders.toString()),
                    ListEntryItem(text: _viewModel.visibleAllServicemenList[index].earnings.toString()),
                    ListEntryItem(text: switch(_viewModel.visibleAllServicemenList[index].gender!) {
                      Gender.male => lang_key.male.tr,
                      Gender.female => lang_key.female.tr,
                      Gender.other => lang_key.other.tr,
                    },),
                    // TwoStatesWidget(status: _viewModel.visibleAllServiceMenList[index].status! == UserStatuses.active, falseStateText: lang_key.suspended.tr,),
                    ListActionsButtons(
                        includeDelete: _viewModel.visibleAllServicemenList[index].status! == UserStatuses.active,
                        includeEdit: false,
                        includeView: true,
                      onViewPressed: () => Get.toNamed(Routes.servicemanDetails, arguments: {'servicemanDetails': _viewModel.visibleAllServicemenList[index], 'sidePanelItem': lang_key.servicemenList.tr, 'sidePanelRouteName': Routes.servicemenList}),
                      deleteIcon: _viewModel.visibleAllServicemenList[index].status! == UserStatuses.active ? CupertinoIcons.nosign : null,
                      onDeletePressed: _viewModel.visibleAllServicemenList[index].status! == UserStatuses.active ? () => showConfirmationDialog(
                          onPressed: () =>_viewModel.showSuspensionNoteDialog(index),
                          message: lang_key.suspensionConfirmationMessage.tr
                      ) : null,
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

// /// Active customers list tab view
// class _ActiveServicemenListTabView extends StatelessWidget {
//   _ActiveServicemenListTabView();
//
//   final ServiceMenListViewModel _viewModel = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(() => ListBaseContainer(
//               onSearch: (value) => _viewModel.searchList(value, _viewModel.allActiveServiceMenList, _viewModel.visibleActiveServicemenList),
//               onRefresh: () => _viewModel.fetchServicemenWithStatus(true),
//               controller: _viewModel.activeServiceMansSearchController,
//               listData: _viewModel.visibleActiveServicemenList,
//               expandFirstColumn: false,
//               hintText: lang_key.searchServiceman.tr,
//               columnsNames: [
//                 lang_key.sl.tr,
//                 lang_key.name.tr,
//                 lang_key.contactInfo.tr,
//                 lang_key.gender.tr,
//                 lang_key.totalOrders.tr,
//                 lang_key.earning.tr,
//                 lang_key.actions.tr
//               ],
//             entryChildren: List.generate(_viewModel.visibleActiveServicemenList.length, (index) {
//               return Padding(
//                 padding: listEntryPadding,
//                 child: Row(
//                   children: [
//                     ListSerialNoText(index: index),
//                     ListEntryItem(text: _viewModel.visibleActiveServicemenList[index].name!),
//                     ContactInfoInList(email: _viewModel.visibleActiveServicemenList[index].email!, phoneNo: _viewModel.visibleActiveServicemenList[index].phoneNo!,),
//                     ListEntryItem(text: switch(_viewModel.visibleActiveServicemenList[index].gender!) {
//
//                       Gender.male => lang_key.male.tr,
//                       Gender.female => lang_key.female.tr,
//                       Gender.other => lang_key.other.tr,
//                     },),
//                     ListEntryItem(text: _viewModel.visibleActiveServicemenList[index].totalOrders.toString()),
//                     ListEntryItem(text: _viewModel.visibleActiveServicemenList[index].earnings.toString()),
//                     ListActionsButtons(
//                       includeDelete: true,
//                       includeEdit: false,
//                       includeView: true,
//                       onViewPressed: () {},
//                       deleteIcon: CupertinoIcons.nosign,
//                       onDeletePressed: () => showConfirmationDialog(onPressed: () {}, message: lang_key.suspensionConfirmationMessage.tr),
//                     )
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Inactive customers list tab view
// class _InActiveServicemenListTabView extends StatelessWidget {
//   _InActiveServicemenListTabView();
//
//   final ServiceMenListViewModel _viewModel = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(() => ListBaseContainer(
//               onSearch: (value) => _viewModel.searchList(value, _viewModel.allInActiveServiceMenList, _viewModel.visibleInActiveServicemenList),
//               onRefresh: () => _viewModel.fetchServicemenWithStatus(false),
//               controller: _viewModel.inActiveServiceMansSearchController,
//               listData: _viewModel.visibleInActiveServicemenList,
//               expandFirstColumn: false,
//               hintText: lang_key.searchServiceman.tr,
//               columnsNames: [
//                 lang_key.sl.tr,
//                 lang_key.name.tr,
//                 lang_key.contactInfo.tr,
//                 lang_key.gender.tr,
//                 lang_key.totalOrders.tr,
//                 lang_key.earning.tr,
//                 lang_key.actions.tr
//               ],
//           entryChildren: List.generate(_viewModel.visibleInActiveServicemenList.length, (index) {
//             return Padding(
//               padding: listEntryPadding,
//               child: Row(
//                 children: [
//                   ListSerialNoText(index: index),
//                   ListEntryItem(text: _viewModel.visibleInActiveServicemenList[index].name!),
//                   ContactInfoInList(email: _viewModel.visibleInActiveServicemenList[index].email!, phoneNo: _viewModel.visibleInActiveServicemenList[index].phoneNo!,),
//                   ListEntryItem(text: switch(_viewModel.visibleInActiveServicemenList[index].gender!) {
//
//                     Gender.male => lang_key.male.tr,
//                     Gender.female => lang_key.female.tr,
//                     Gender.other => lang_key.other.tr,
//                   },),
//                   ListEntryItem(text: _viewModel.visibleInActiveServicemenList[index].totalOrders.toString()),
//                   ListEntryItem(text: _viewModel.visibleInActiveServicemenList[index].earnings.toString()),
//                   ListActionsButtons(
//                     includeDelete: true,
//                     includeEdit: false,
//                     includeView: true,
//                     onViewPressed: () {},
//                     deleteIcon: CupertinoIcons.nosign,
//                     onDeletePressed: () => showConfirmationDialog(onPressed: () {}, message: lang_key.suspensionConfirmationMessage.tr),
//                   )
//                 ],
//               ),
//             );
//           }),
//         )),
//       ],
//     );
//   }
// }