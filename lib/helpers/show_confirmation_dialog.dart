import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';

Future<void> showConfirmationDialog({
  String title = '',
  String message = '',
  required Function() onPressed,
  bool isDeletion = true
}) {
  return showDialog(
      context: Get.context!,
      barrierColor: Colors.black38,
      builder: (context) {
    return AlertDialog(
      iconColor: primaryGrey,
      iconPadding: EdgeInsets.symmetric(vertical: 8),
      icon: Icon(CupertinoIcons.exclamationmark_circle_fill, size: 80,),
      title: Text(isDeletion ? title != '' ? title : lang_key.areYouSure.tr : title),
      backgroundColor: primaryWhite,
      content: Text(
        isDeletion ? message != '' ? message : lang_key.deletionConfirmationMessage.tr : message,
        textAlign: TextAlign.center,
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        CustomMaterialButton(
          width: 200,
          onPressed: onPressed,
          text: lang_key.yes.tr,
        ),
        CustomMaterialButton(
          width: 200,
          onPressed: () => Get.back(),
          text: lang_key.cancel.tr,
          borderColor: primaryGrey,
          textColor: primaryWhite,
          buttonColor: primaryGrey,
        ),
      ],
    );
  });
}