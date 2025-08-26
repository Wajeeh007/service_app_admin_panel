import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/local_storage_functions.dart';
import 'package:service_app_admin_panel/models/admin.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../utils/routes.dart';

class SplashViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  RxDouble imageWidth = 0.0.obs;

  late AnimationController animationController;
  late Animation animation;

  @override
  void onReady() {
    Future.delayed(Duration(milliseconds: 500), () {
      animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
      animation = CurvedAnimation(parent: animationController, curve: Curves.elasticOut);
      animationController.forward();
      animation.addListener(() {
        imageWidth.value = animation.value * 400;
        if(animationController.isCompleted) {
          _routeUser();
        }
      });
    });
    super.onReady();
  }

  void _routeUser() async {
    final isLoggedIn = await LocalStorageFunctions.readFromStorage(key: isLoggedInKey);

    if(isLoggedIn != null && isLoggedIn) {

      final token = await LocalStorageFunctions.readFromStorage(key: tokenKey,);

      if(token != null && token.isNotEmpty) {
        GlobalVariables.token = token;
        _getUserProfile();
      } else {
        Get.offAllNamed(Routes.login);
      }
    } else {
      Get.offAllNamed(Routes.login);
    }
  }

  void _getUserProfile() {
    ApiBaseHelper.getMethod(
        url: Urls.getUserProfile
    ).then((value) {
      ApiBaseHelper.getMethod(url: Urls.getUserProfile).then((value) {
        if(value.success!) {
          GlobalVariables.userDetails.value = Admin.fromJson(value.data);
          Get.offAllNamed(Routes.dashboard);
        } else if(value.statusCode == 401) {
          return ;
        } else {
          Get.offAllNamed(Routes.login);
        }
      });
    });
  }
}