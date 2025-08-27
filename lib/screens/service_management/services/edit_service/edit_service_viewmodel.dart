import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/scroll_controller_funcs.dart';
import 'package:service_app_admin_panel/models/service_category.dart';
import 'package:service_app_admin_panel/screens/service_management/services/service_list/service_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../../utils/routes.dart';

class EditServiceViewModel extends GetxController {

  /// Controller(s) & Form Keys
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  GlobalKey<FormState> serviceDetailsFormKey = GlobalKey<FormState>();

  /// New File to be uploaded
  Rx<Uint8List> newImageToUpload = Uint8List(0).obs;

  /// Network Image observable variable.
  RxString imageUrl = ''.obs;

  ServiceCategory serviceDetails = ServiceCategory();

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;
    if(args == null || args.isEmpty) {
      Get.offAllNamed(Routes.servicesList);
    } else {
      serviceDetails = args['serviceDetails'];
      initializeControllers();
      animateSidePanelScrollController(scrollController, routeName: Routes.servicesList);
    }
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    scrollController.dispose();
    newImageToUpload.value = Uint8List(0);
    super.onClose();
  }

  /// Call the edit API
  //TODO: Handle request for images.
  void editService() {
    if(serviceDetailsFormKey.currentState!.validate()){
      GlobalVariables.showLoader.value = true;

      var body = {};

      if(nameController.text != serviceDetails.name!) body.addAll({'name': nameController.text});
      if(descController.text != serviceDetails.desc!) body.addAll({'desc': descController.text});

      ApiBaseHelper.patchMethod(
          url: Urls.editService(serviceDetails.id!), body: body).then((value) {
         GlobalVariables.showLoader.value = false;

         if(value.success!) {
           ServiceListViewModel serviceListViewModel = Get.find();
           serviceListViewModel.allServicesList[serviceListViewModel.allServicesList.indexWhere((element) => element.id == serviceDetails.id)] = ServiceCategory.fromJson(value.data);
           serviceListViewModel.addServicesToVisibleList();
           Get.back();
         }

         showSnackBar(message: value.message!, success: value.success!);
      });
    }
  }

  /// Initialize controllers and their values.
  void initializeControllers() {
    nameController.text = serviceDetails.name!;
    descController.text = serviceDetails.desc!;
    imageUrl.value = serviceDetails.image!;
  }
}