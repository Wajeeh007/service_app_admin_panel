import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/constants.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/custom_appbar.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/custom_dropdown.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/sidepanel.dart';
import 'package:service_app_admin_panel/helpers/images_paths.dart';
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
        onTap: () => _viewModel.toggleOverlayPortalController(),
        child: Row(
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
                      })
                    ],
                  ),
                ),
              ),
            )
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
                    suffixIcon: _viewModel.suffixIcon,
                    overlayToggleFunc: () => _viewModel.toggleOverlayPortalController(),
                    buttonBorderColor: primaryGrey.withValues(alpha: 0.2),
                    buttonColor: primaryGrey.withValues(alpha: 0.2),
                    selectedItem: _viewModel.selectedItem,
                    textEditingController: _viewModel.controller,
                    dropDownList: _viewModel.dropDownList,
                    overlayPortalController: _viewModel.overlayPortalController,
                    link: _viewModel.link,
                    width: 130,
                    height: 30,
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

