import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/models/withdraw_method.dart';
import 'package:service_app_admin_panel/screens/withdraw/withdraw_methods_list/withdraw_methods_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

class EditWithdrawMethodViewModel extends GetxController {
  
  /// Controller(s) and Form Key(s)
  
  ScrollController scrollController = ScrollController();
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  TextEditingController methodNameController = TextEditingController();
  TextEditingController fieldNameController = TextEditingController();
  TextEditingController placeholderTextController = TextEditingController();
  TextEditingController fieldTypeController = TextEditingController();
  OverlayPortalController fieldTypeOverlayPortalController = OverlayPortalController();

  /// Show dropdown value
  RxBool showDropDown = false.obs;

  /// Dropdown selected value
  RxString dropDownSelectedValue = ''.obs;

  /// Checkbox value
  RxBool checkBoxValue = false.obs;

  /// Withdraw Method details
  WithdrawMethod withdrawMethod = WithdrawMethod();

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;

    if(args == null || args.isEmpty) {
      Get.offAllNamed(Routes.withdrawMethods);
    } else {
      withdrawMethod = args['withdrawMethodDetails'];
      initializeControllersAndValues();
    }
    super.onReady();
  }

  /// Call API to edit the details of the withdraw method.
  void editWithdrawMethod() {
    if(formKey.currentState!.validate()) {

      var body = {};

      if(methodNameController.text != withdrawMethod.name) body.addAll({'name': methodNameController.text});
      if(fieldTypeController.text != withdrawMethod.fieldType!.name) body.addAll({'field_type': fieldTypeController.text});
      if(fieldNameController.text != withdrawMethod.fieldName) body.addAll({'field_name': fieldNameController.text});
      if(placeholderTextController.text != withdrawMethod.placeholderText) body.addAll({'placeholder_text': placeholderTextController.text});
      if(checkBoxValue.value != withdrawMethod.isDefault) body.addAll({'is_default': checkBoxValue.value ? 1 : 0});

      if(body.isEmpty) {
        showSnackBar(message: lang_key.noInfoChanged.tr, success: false);
      } else {
        GlobalVariables.showLoader.value = true;

        ApiBaseHelper.patchMethod(
          url: Urls.editWithdrawMethod(withdrawMethod.id!),
          body: body,
        ).then((value) {
          stopLoaderAndShowSnackBar(message: value.message!, success: value.success!, goBack: true);

          if(value.success!) {
            WithdrawMethodsListViewModel withdrawMethodsListViewModel = Get.find<WithdrawMethodsListViewModel>();

            final allMethodsListIndex = withdrawMethodsListViewModel.allMethodsList.indexWhere((element) => element.id == withdrawMethod.id!);
            if(allMethodsListIndex != -1) {
              withdrawMethodsListViewModel.allMethodsList[allMethodsListIndex] = WithdrawMethod.fromJson(value.data);
              changeDefaultMethodInList(withdrawMethodsListViewModel.allMethodsList, withdrawMethodsListViewModel.visibleAllMethodsList, body.containsKey('is_default'));
            }

            if(withdrawMethod.status!) {
              int activeMethodsListIndex = withdrawMethodsListViewModel.activeMethodsList.indexWhere((element) => element.id == withdrawMethod.id!);
              if(activeMethodsListIndex != -1) {
                withdrawMethodsListViewModel.activeMethodsList[activeMethodsListIndex] = WithdrawMethod.fromJson(value.data);
                changeDefaultMethodInList(withdrawMethodsListViewModel.activeMethodsList, withdrawMethodsListViewModel.visibleActiveMethodsList, body.containsKey('is_default'));
              }
            } else {
              int inActiveMethodsListIndex = withdrawMethodsListViewModel.inActiveMethodsList.indexWhere((element) => element.id == withdrawMethod.id!);
              if(inActiveMethodsListIndex != -1) {
                withdrawMethodsListViewModel.inActiveMethodsList[inActiveMethodsListIndex] = WithdrawMethod.fromJson(value.data);
                addDataToVisibleList(withdrawMethodsListViewModel.inActiveMethodsList, withdrawMethodsListViewModel.visibleInActiveMethodsList);
              }
            }
          }
        });
      }
    }
  }

  void changeDefaultMethodInList(List<WithdrawMethod> allList, RxList<WithdrawMethod> visibleList, bool changeDefaultMethod) {
    if(changeDefaultMethod) {
      for (var element in allList) {
        if (element.id != withdrawMethod.id) {
          element.isDefault = false;
        }

        if (element == allList.last) {
          addDataToVisibleList(allList, visibleList);
        }
      }
    } else {
      addDataToVisibleList(allList, visibleList);
    }
  }

  /// Initialize values of Withdraw Method for editing.
  void initializeControllersAndValues() {
    methodNameController.text = withdrawMethod.name!;
    fieldNameController.text = withdrawMethod.fieldName!;
    placeholderTextController.text = withdrawMethod.placeholderText!;
    fieldTypeController.text = withdrawMethod.fieldType!.name;
    checkBoxValue.value = withdrawMethod.isDefault!;
  }
}