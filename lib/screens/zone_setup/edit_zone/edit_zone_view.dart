import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

class EditZoneView extends StatelessWidget {
  const EditZoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.zoneSetup.tr,
        children: [
          SectionHeadingText(headingText: lang_key.zoneSetup.tr),
        ]
    );
  }
}
