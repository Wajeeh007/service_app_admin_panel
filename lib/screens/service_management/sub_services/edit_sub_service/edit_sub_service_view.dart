import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/service_management/sub_services/edit_sub_service/edit_sub_service_viewmodel.dart';

class EditSubServiceView extends StatelessWidget {
  EditSubServiceView({super.key});

  final EditSubServiceViewModel _viewModel = Get.put(EditSubServiceViewModel());
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
