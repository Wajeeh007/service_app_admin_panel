import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/heading_in_container_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_tab_bar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'business_setup_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class BusinessSetupView extends StatelessWidget {
  BusinessSetupView({super.key});

  final BusinessSetupViewModel _viewModel = Get.put(BusinessSetupViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.businessSetup.tr,
        children: [
          CustomTabBar(
              controller: _viewModel.tabController,
              tabsNames: _viewModel.tabsNames
          ),
          Container(
            decoration: kContainerBoxDecoration,
            padding: basePaddingForContainers,
            child: Column(
              children: [
                HeadingInContainerText(text: lang_key.businessInfo.tr),
              ],
            ),
          )
        ]
    );
  }
}
