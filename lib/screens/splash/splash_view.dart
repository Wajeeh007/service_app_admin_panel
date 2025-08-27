import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/splash/splash_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final SplashViewModel _viewModel = Get.put(SplashViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      body: Center(
        child: Obx(() => Image.asset(
          ImagesPaths.adawatLogo,
          width: _viewModel.imageWidth.value,
          // height: 120,
          fit: BoxFit.fitWidth,
        )),
      ),
    );
  }
}
