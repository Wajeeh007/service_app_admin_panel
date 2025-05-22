import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/zone_model.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/helper_functions/show_snackbar.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class EditZoneViewModel extends GetxController {

  /// Controller(s) & Form Keys
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Zone Details of the selected zone
  ZoneModel zoneDetails = ZoneModel();

  /// Polygon string
  String areaPolygon = '';

  void editZone() {
    if (nameController.text == zoneDetails.name! && zoneDetails.polylines == areaPolygon) {
      showSnackBar(
          message: lang_key.zoneDetailsNotChanged,
          isError: true
      );
    } else {

      GlobalVariables.showLoader.value = true;

      final body = {
        'name': nameController.text,
        'desc': descController.text,
        'polylines': areaPolygon,
      };

      ApiBaseHelper.patchMethod(
          url: Urls.editZone(zoneDetails.id.toString()),
          body: body
      ).then((value) {
        if(value.success!
        ) {

        }
      });
    }
  }
  
}