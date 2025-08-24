import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_dropdown.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/screens/dashboard/dashboard_viewmodel.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardViewModel _viewModel = Get.put(DashboardViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
      scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.dashboard.tr,
        overlayPortalControllersAndShowDropDown: _viewModel.overlayPortalControllersAndDropDownValues,
        children: [
          _WelcomeText(),
          LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: 313,
              width: constraints.maxWidth,
              child: Row(
                spacing: 15,
                children: [
                  _TextStats(),
                  _ZoneWiseOrderStats()
                ],
              ),
            );
          }),
          _AdminEarningStatsGraph()
        ]
    );
  }
}

/// Welcome Text at the top of the screen
class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SectionHeadingText(headingText: lang_key.welcomeAdmin.tr),
        Text(
          lang_key.monitorYourBusinessStatistics.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500
          ),
        )
      ],
    );
  }
}

/// Total active customers, servicemen, total earnings and orders section
class _TextStats extends StatelessWidget {
  _TextStats();

  final DashboardViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                SmallStatisticTile(
                  text: lang_key.activeCustomers.tr,
                  value: _viewModel.userStats.value.totalActiveCustomers != null ? _viewModel.userStats.value.totalActiveCustomers.toString() : '',
                  iconOrImageBgColor: primaryBlue,
                  icon: Icons.person,
                ),
                SmallStatisticTile(
                  text: lang_key.totalEarnings.tr,
                  value: '\$ ${_viewModel.userStats.value.totalEarning ?? ''}',
                  iconOrImageBgColor: Color(0xffF89D1F),
                  icon: Icons.currency_exchange_outlined,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                SmallStatisticTile(
                  text: lang_key.activeServicemen.tr,
                  value: _viewModel.userStats.value.totalActiveServicemen != null ? _viewModel.userStats.value.totalActiveServicemen.toString() : '',
                  iconOrImageBgColor: Colors.purpleAccent,
                  image: ImagesPaths.servicemen,
                ),
                SmallStatisticTile(
                  text: lang_key.totalOrders.tr,
                  value: _viewModel.userStats.value.totalOrders != null ? _viewModel.userStats.value.totalOrders.toString() : '',
                  iconOrImageBgColor: Colors.green,
                  icon: Icons.receipt,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Zone wise orders stats
class _ZoneWiseOrderStats extends StatelessWidget {
  _ZoneWiseOrderStats();

  final DashboardViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: kContainerBorderRadius,
            color: primaryWhite,
            border: kContainerBorderSide
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang_key.zoneWiseOrders.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600
                  )
                ),
                CustomDropdown(
                  selectedValueId: _viewModel.zoneWiseStatSelectedId,
                  textEditingController: _viewModel.zoneWiseStatController,
                  showDropDown: _viewModel.zoneWiseStatsShowDropDown,
                  dropDownList: _viewModel.zoneWiseStatsDropDownList,
                  overlayPortalController: _viewModel.zoneWiseStatOverlayPortalController,
                  onChanged: () => _viewModel.fetchZoneWiseOrderVolume(),
                  onTap: () => _viewModel.zoneWiseStatsShowDropDown.value = !_viewModel.zoneWiseStatsShowDropDown.value,
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Obx(() => Column(
                    children: List.generate(_viewModel.zoneWiseOrderVolumeList.length, (index) {
                      return _ZoneOrderVolumeItem(index: index);

                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Zone order volume stat widget
class _ZoneOrderVolumeItem extends StatelessWidget {
  _ZoneOrderVolumeItem({required this.index});

  final int index;
  
  final DashboardViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _viewModel.zoneWiseOrderVolumeList[index].zoneName!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: primaryGrey
                ),
              ),
              Text(
                '${_viewModel.zoneWiseOrderVolumeList[index].percentage!.toStringAsFixed(0)}% Order Volume',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: primaryGrey
                ),
              )
            ],
          ),
          Container(
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
                      _viewModel.zoneWiseOrderVolumeList[index].percentage!,
                      _viewModel.zoneWiseOrderVolumeList[index].percentage!,
                      1
                    ]
                )
            ),
          )
        ],
      ),
    );
  }
}

/// Dashboard small statistic tile
class SmallStatisticTile extends StatelessWidget {
  const SmallStatisticTile({
    super.key,
    required this.text,
    required this.value,
    required this.iconOrImageBgColor,
    this.image,
    this.icon,
  }) : assert(icon != null || image != null, 'Either provide icon or image'),
        assert(icon == null || image == null, 'Cannot provide both icon and image');

  final String text;
  final String value;
  final String? image;
  final IconData? icon;
  final Color iconOrImageBgColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
        decoration: BoxDecoration(
          borderRadius: kContainerBorderRadius,
          color: primaryWhite,
          border: kContainerBorderSide
        ),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: kContainerBorderRadius,
                border: Border.all(color: iconOrImageBgColor),
                color: iconOrImageBgColor
              ),
              child: icon != null ? Icon(
                icon!,
                size: 30,
                color: primaryWhite,
              ) : Image.asset(
                image!,
                width: 30,
                height: 30,
                fit: BoxFit.fill,
                color: primaryWhite,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: primaryGrey
              ),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}

/// Admin Earning Statistics graph
class _AdminEarningStatsGraph extends StatelessWidget {
  _AdminEarningStatsGraph();

  final DashboardViewModel _viewModel = Get.find();
  
  @override
  Widget build(BuildContext context) {

    // print(DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day.toDouble());

    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
          borderRadius: kContainerBorderRadius,
          color: primaryWhite,
          border: kContainerBorderSide
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AdminEarningHeadingAndZoneName(),
              Row(
                spacing: 10,
                children: [
                  CustomDropdown(
                    textEditingController: _viewModel.adminEarningTimePeriodController,
                    dropDownList: _viewModel.adminEarningTimePeriodDropdownList,
                    overlayPortalController: _viewModel.adminEarningTimePeriodOverlayPortalController,
                    selectedValueId: _viewModel.adminEarningTimePeriodSelectedId,
                    showDropDown: _viewModel.adminEarningTimePeriodShowDropDown,
                    onTap: () => _viewModel.adminEarningTimePeriodShowDropDown.value = !_viewModel.adminEarningTimePeriodShowDropDown.value,
                    onChanged: () {
                      if(_viewModel.adminEarningTimePeriodSelectedId.value != _viewModel.adminEarningTimePeriodController.text){
                        _viewModel.adminEarningTimePeriodSelectedId.value =
                            _viewModel.adminEarningTimePeriodDropdownList
                                .firstWhere((element) =>
                                    element.label ==
                                    _viewModel
                                        .adminEarningTimePeriodController.text)
                                .value;
                        _viewModel.fetchAdminEarningStats();
                      }
                    },
                  ),
                  CustomDropdown(
                    textEditingController: _viewModel.adminEarningZoneSelectionController,
                    dropDownList: _viewModel.adminEarningZoneSelectionList,
                    overlayPortalController: _viewModel.adminEarningZoneSelectionOverlayPortalController,
                    selectedValueId: _viewModel.adminEarningZoneSelectionSelectedId,
                    showDropDown: _viewModel.adminEarningZoneSelectionShowDropDown,
                    onTap: () => _viewModel.adminEarningZoneSelectionShowDropDown.value = !_viewModel.adminEarningZoneSelectionShowDropDown.value,
                    onChanged: () {
                      if(_viewModel.adminEarningZoneSelectionSelectedId.value != _viewModel.adminEarningZoneSelectionController.text) {
                        _viewModel.adminEarningZoneSelectionSelectedId.value = _viewModel.adminEarningZoneSelectionList.firstWhere((element) => element.label == _viewModel.adminEarningZoneSelectionController.text).value;
                        _viewModel.fetchAdminEarningStats();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Obx(() => LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(
                            enabled: false
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border: Border(
                                left: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary
                                ),
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.secondary
                              )
                            )
                        ),
                        gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6),
                                  strokeWidth: 1
                              );
                            },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              // interval: 1,
                              // reservedSize: _viewModel.adminEarningTimePeriodSelectedId.value == 'Daily' ? DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day.toDouble() : _viewModel.adminEarningTimePeriodSelectedId.value == 'Monthly' ? 12 : 10,
                              interval: _viewModel.adminEarningTimePeriodSelectedId.value == 'Daily' ? 0.5 : 1,
                              getTitlesWidget: (value, meta) => BottomTitleWidget(value: value, meta: meta,),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) => LeftTitleWidget(value: value, meta: meta),
                              reservedSize: 42,
                            ),
                          ),
                        ),
                        minX: 0,
                        maxX: _viewModel.adminEarningTimePeriodSelectedId.value == 'Daily' ? ((DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - 1) / 2).toDouble() : 11,
                        minY: _viewModel.graphData.value.min != null ? _viewModel.graphData.value.min == _viewModel.graphData.value.max ? 0 : _viewModel.graphData.value.min!.toDouble() : 0,
                        maxY: _viewModel.graphData.value.min != null ? _viewModel.graphData.value.max == 0 ? 6 : _viewModel.graphData.value.max!.toDouble() : 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _viewModel.graphData.value.dailyPoints ?? [
                              FlSpot(0, 0.1),
                              FlSpot(11, 0.1)
                            ],
                            isCurved: true,
                            barWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                                show: true,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                            ),
                          ),
                        ],
                      )
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Widget for returning text at the bottom of chart
class BottomTitleWidget extends StatelessWidget {
  BottomTitleWidget({super.key, required this.value, required this.meta});

  final double value;
  final TitleMeta meta;

  final DashboardViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    String text;
    final style = Theme.of(context).textTheme.labelMedium;

    if(_viewModel.adminEarningTimePeriodSelectedId.value == 'Daily') {
        text = ((value * 2) + 1).toString();
    } else if(_viewModel.adminEarningTimePeriodSelectedId.value == 'Monthly') {
      text = months[value.toInt()].substring(0, 3);
    } else {
      text = (DateTime.now().year - 11 + value).toString();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style,),
    );
  }
}

/// Widget for returning text at left side of the chart
class LeftTitleWidget extends StatelessWidget {
  LeftTitleWidget({super.key, required this.value, required this.meta});

  final double value;
  final TitleMeta meta;

  final DashboardViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {

    final style = Theme.of(context).textTheme.labelMedium;
    String text;

    if(_viewModel.graphData.value.min != null) {

      if(_viewModel.graphData.value.min == _viewModel.graphData.value.max) {
        if(value == 0) {
          text = '0';
        } else if(value == _viewModel.graphData.value.max!/2) {
          text = (_viewModel.graphData.value.max! / 2).toInt().toString();
        } else if(value == _viewModel.graphData.value.max){
          text = _viewModel.graphData.value.max.toString();
        } else {
          text = '';
        }
      } else {
        if (value == _viewModel.graphData.value.min) {
          text = _viewModel.graphData.value.min.toString();
        } else if (value == _viewModel.graphData.value.avg) {
          text = _viewModel.graphData.value.avg.toString();
        } else if (value == _viewModel.graphData.value.max) {
          text = _viewModel.graphData.value.max.toString();
        } else {
          text = '';
        }
      }
    } else {
      if(value.toInt() == 0) {
        text = '0';
      } else {
        text = '';
      }
    }

    // switch (value.toInt()) {
    //   case 0:
    //     text = _viewModel.graphData.value.min != null ? _viewModel.graphData.value.min == _viewModel.graphData.value.max ? '0' : _viewModel.graphData.value.min.toString() : '';
    //     break;
    //   // case 1:
    //   //   text = '10K';
    //   //   break;
    //   case _viewModel.graphData.value.avg != null ? :
    //     text = _viewModel.graphData.value.avg != null ? _viewModel.graphData.value.min == _viewModel.graphData.value.max ? (_viewModel.graphData.value.max! / 2).toString() : _viewModel.graphData.value.avg.toString() : '';
    //     break;
    //   case 5:
    //     text = _viewModel.graphData.value.max != null ? _viewModel.graphData.value.max.toString() : '';
    //     break;
    //   default:
    //     return SizedBox();
    // }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}

/// Admin earning heading and selected zone text
class _AdminEarningHeadingAndZoneName extends StatelessWidget {
  _AdminEarningHeadingAndZoneName();

  final DashboardViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          lang_key.adminEarningStatistics.tr,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600
          ),
        ),
        Text(
          _viewModel.adminEarningZoneSelectionController.text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: primaryGrey
          ),
        )
      ],
    );
  }
}