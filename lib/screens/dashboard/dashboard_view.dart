import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_appbar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_dropdown.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/sidepanel.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/screens/dashboard/dashboard_viewmodel.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardViewModel _viewModel = Get.put(DashboardViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _viewModel.hideAllOverlayPortalControllers(),
        child: Stack(
          children: [
            Row(
              children: [
                SidePanel(selectedItem: lang_key.dashboard.tr,),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
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
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            ProfileDropDown(),
            ProfileDropDownContainer(),

          ],
        ),
      )
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
        Text(
          lang_key.welcomeAdmin.tr,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600
          ),
        ),
        Text(
          lang_key.monitorYourBusinessStatistics.tr,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}

/// Total active customers, servicemen, total earnings and orders section
class _TextStats extends StatelessWidget {
  const _TextStats();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              SmallStatisticTile(
                text: lang_key.activeCustomers.tr,
                value: '05',
                iconOrImageBgColor: primaryBlue,
                icon: Icons.person,
              ),
              SmallStatisticTile(
                text: lang_key.totalEarnings.tr,
                value: '\$ 10',
                iconOrImageBgColor: Color(0xffF89D1F),
                icon: Icons.currency_exchange_outlined,
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              SmallStatisticTile(
                text: lang_key.activeServicemen.tr,
                value: '05',
                iconOrImageBgColor: Colors.purpleAccent,
                image: ImagesPaths.servicemen,
              ),
              SmallStatisticTile(
                text: lang_key.totalOrders.tr,
                value: '10',
                iconOrImageBgColor: Colors.green,
                icon: Icons.receipt,
              )
            ],
          ),
        ],
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
                  ),
                ),
                Flexible(
                  child: CustomDropdown(
                    suffixIcon: _viewModel.zoneWiseStatsSuffixIcon,
                    overlayToggleFunc: () => _viewModel.toggleOverlayPortalController(
                        overlayPortalController: _viewModel.zoneWiseStatOverlayPortalController,
                      suffixIcon: _viewModel.zoneWiseStatsSuffixIcon
                    ),
                    selectedItemIndex: _viewModel.zoneWiseStatSelectedItemIndex,
                    dropDownList: _viewModel.zoneWiseStatsDropDownList,
                    overlayPortalController: _viewModel.zoneWiseStatOverlayPortalController,
                    link: _viewModel.zoneWiseStatLink,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: List.generate(_viewModel.zoneWiseOrderVolumeList.length, (index) {
                    return _ZoneOrderVolumeItem(index: index);
                        
                  }),
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
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _viewModel.zoneWiseOrderVolumeList[index].zoneName!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: primaryGrey
              ),
            ),
            Text(
              '${_viewModel.zoneWiseOrderVolumeList[index].percentage! * 100}% Order Volume',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
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
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                      dropDownList: _viewModel.adminEarningTimePeriodDropdownList,
                      overlayPortalController: _viewModel.adminEarningTimePeriodOverlayPortalController,
                      link: _viewModel.adminEarningTimePeriodLink,
                      selectedItemIndex: _viewModel.adminEarningTimePeriodSelectedItemIndex,
                      overlayToggleFunc: () => _viewModel.toggleOverlayPortalController(
                        overlayPortalController: _viewModel.adminEarningTimePeriodOverlayPortalController,
                        suffixIcon: _viewModel.adminEarningTimePeriodSuffixIcon
                      ), suffixIcon: _viewModel.adminEarningTimePeriodSuffixIcon,
                  ),
                  CustomDropdown(
                      dropDownList: _viewModel.adminEarningZoneSelectionList,
                      overlayPortalController: _viewModel.adminEarningZoneSelectionOverlayPortalController,
                      link: _viewModel.adminEarningZoneSelectionLink,
                      selectedItemIndex: _viewModel.adminEarningZoneSelectionSelectedItemIndex,
                      overlayToggleFunc: () => _viewModel.toggleOverlayPortalController(
                        overlayPortalController: _viewModel.adminEarningZoneSelectionOverlayPortalController,
                        suffixIcon: _viewModel.adminEarningZoneSelectionSuffixIcon
                      ), suffixIcon: _viewModel.adminEarningZoneSelectionSuffixIcon,
                  ),
                ],
              )
            ],
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: LineChart(
                  LineChartData(
                    lineTouchData: const LineTouchData(
                        enabled: false
                    ),
                    borderData: FlBorderData(
                        show: false,
                        // border: Border.all(
                        //     color: Theme.of(context).colorScheme.secondary
                        // )
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
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
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
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 3.1),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        isCurved: false,
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
          )
        ],
      ),
    );
  }
}

/// Widget for returning text at the bottom of chart
class BottomTitleWidget extends StatelessWidget {
  const BottomTitleWidget({super.key, required this.value, required this.meta});

  final double value;
  final TitleMeta meta;

  @override
  Widget build(BuildContext context) {

    String text;
    final style = Theme.of(context).textTheme.labelMedium;

    text = months[value.toInt()].substring(0, 3);

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style,),
    );
  }
}

/// Widget for returning text at left side of the chart
class LeftTitleWidget extends StatelessWidget {
  const LeftTitleWidget({super.key, required this.value, required this.meta});

  final double value;
  final TitleMeta meta;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30K';
        break;
      case 5:
        text = '50K';
        break;
      default:
        return Container();
    }

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
        Obx(() => Text(
          _viewModel.adminEarningZoneSelectionList[_viewModel.adminEarningZoneSelectionSelectedItemIndex.value].label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: primaryGrey
          ),
        ))
      ],
    );
  }
}

/// Base widget for the profile dropdown
class ProfileDropDown extends StatelessWidget {
  const ProfileDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GlobalVariables.openProfileDropdown.value ? Positioned(
      right: 20,
      top: 0,
      child: CustomPaint(
        painter: TrianglePainter(
            strokeColor: primaryWhite,
            strokeWidth: 10,
            paintingStyle: PaintingStyle.fill
        ),
        child: const SizedBox(
          height: 8,
          width: 10,
        ),
      ),
    ) : const SizedBox()
    );
  }
}

/// Container beneath the triangle for the profile dropdown
class ProfileDropDownContainer extends StatelessWidget {
  const ProfileDropDownContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GlobalVariables.openProfileDropdown.value ? Positioned(
      right: 10,
      top: 7,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryWhite
        ),
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                minTileHeight: 20,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                title: Text(
                  lang_key.logout.tr,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
                trailing: Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    ) : const SizedBox()
    );
  }
}

/// Custom painter class for creating a triangle
class TrianglePainter extends CustomPainter {

  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}