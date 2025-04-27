import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/custom_appbar.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/sidepanel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
      ),
      body: Row(
        children: [
          SidePanel(selectedItem: lang_key.dashboard.tr,),

        ],
      )
    );
  }
}