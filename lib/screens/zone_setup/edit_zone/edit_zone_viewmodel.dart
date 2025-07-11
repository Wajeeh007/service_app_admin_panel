import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/format_polygon.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/zone.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_list_and_addition/zone_list_and_addition_viewmodel.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/models_and_libraries/map_controller.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class EditZoneViewModel extends GetxController {

  /// Controller(s) & Form Keys
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomGoogleMapController mapController = CustomGoogleMapController();

  /// Zone Details of the selected zone
  ZoneModel zoneDetails = ZoneModel();

  /// Polygon string
  String areaPolygon = '';

  RxBool enableAutoValidation = false.obs;

  @override
  void onReady() {
    zoneDetails = Get.arguments['zoneDetails'];
    _initializeValues();
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    areaPolygon = '';
    scrollController.dispose();
    super.onClose();
  }

  /// Editing existing zone API call.
  void editZone() {
    if (nameController.text == zoneDetails.name! && zoneDetails.desc! == descController.text && zoneDetails.polylines == areaPolygon) {
      showSnackBar(
          message: lang_key.zoneDetailsNotChanged.tr,
          success: false
      );
    } else {
      if (formKey.currentState!.validate()) {
        if (areaPolygon != '') {

            GlobalVariables.showLoader.value = true;

            var body = {};
            
            if(nameController.text != zoneDetails.name!) body['name'] = nameController.text;
            
            if(descController.text != zoneDetails.desc!) body['desc'] = descController.text;
            
            if(areaPolygon != zoneDetails.polylines!) body['polylines'] = areaPolygon;

            ApiBaseHelper.patchMethod(
                    url: Urls.editZone(zoneDetails.id.toString()), body: body)
                .then((value) {
              if (value.success!) {
                ZoneListAndAdditionViewModel zoneViewModel = Get.find();
                final index = zoneViewModel.allZonesList
                    .indexWhere((element) => element.id == zoneDetails.id);
                if(body.containsKey('name')) zoneViewModel.allZonesList[index].name = nameController.text;
                if(body.containsKey('desc')) zoneViewModel.allZonesList[index].desc = descController.text;
                if(body.containsKey('polylines')) zoneViewModel.allZonesList[index].polylines = extractCoords(areaPolygon);
                zoneViewModel.addDataToVisibleZoneList();
                zoneViewModel.mapController.updateZonePolygon?.call({
                  'id': zoneViewModel.allZonesList[index].id.toString(),
                  'polylines': zoneViewModel.allZonesList[index].polylines
                });
                Get.back();
                stopLoaderAndShowSnackBar(
                    message: value.message!, success: value.success!);
              }
            });
        } else {
            showSnackBar(message: lang_key.addAreaPolygon.tr, success: true);
          }
        }
      }
    }
  
  void _initializeValues() {
    nameController.text = zoneDetails.name!;
    descController.text = zoneDetails.desc!;
    areaPolygon = zoneDetails.polylines!;
  }
  
}