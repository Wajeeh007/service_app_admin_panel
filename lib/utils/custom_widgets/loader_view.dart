import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:get/get.dart';

class LoaderView extends StatelessWidget {
  const LoaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => (GlobalVariables.showLoader.value)
          ? Container(
        height: double.infinity,
        width: double.infinity,
        color: primaryGrey20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 1.4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    primaryBlue,
                  ),
                ),
              ),
            )
          ],
        ),
      ) : SizedBox(),
    );
  }
}