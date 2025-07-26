import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/models/zone.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/models_and_libraries/map_controller.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../helpers/stop_loader_and_show_snackbar.dart';

class ZoneListAndAdditionViewModel extends GetxController {

  /// Controller(s) & Global Key(s)
  TextEditingController zoneNameController = TextEditingController();
  TextEditingController zoneDescController = TextEditingController();
  TextEditingController zoneSearchController = TextEditingController();
  GlobalKey<FormState> zoneNameFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  CustomGoogleMapController mapController = CustomGoogleMapController();

  /// Variables for Google Maps ///
    /// Polygon of an area
    String areaPolygons = '';

  /// Variables for Google Maps End ///

  /// Variable for page toggling
  RxInt currentPage = 0.obs;
  RxInt totalPages = 3.obs;

  /// Limit variables
  int limit = 30;

  /// Zones list data
  RxList<ZoneModel> allZonesList = <ZoneModel>[].obs;
  RxList<ZoneModel> visibleZoneList = <ZoneModel>[].obs;

  /// Variable to toggle auto-validation of form fields.
  RxBool enableAutoValidation = true.obs;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    getAllZones();
    determinePosition();
    super.onReady();  
  }

  @override
  void onClose() {
    zoneNameController.dispose();
    zoneDescController.dispose();
    zoneSearchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Fetch the current position of the device
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(message: lang_key.locationServiceDisabled.tr, success: false);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar(message: lang_key.locationPermissionsDenied.tr, success: false);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(message: lang_key.locationPermissionsPermanentlyDenied.tr, success: false);
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: WebSettings(timeLimit: Duration(seconds: 20), accuracy: LocationAccuracy.best)
    );
  }

  /// Add new zone API call.
  void addNewZone() {
    enableAutoValidation.value = true;
    if(zoneNameFormKey.currentState!.validate()) {
      if(areaPolygons != '') {

        GlobalVariables.showLoader.value = true;

        Map<String, dynamic> body = {
          'name': zoneNameController.text,
          'desc': zoneDescController.text,
          'polylines': areaPolygons
        };
        
        ApiBaseHelper.postMethod(
            url: Urls.addNewZone,
            body: body
        ).then((value) {

          stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

          if(value.success!) {
            enableAutoValidation.value = false;
            allZonesList.add(ZoneModel.fromJson(value.data));
            mapController.addToPolygonRefs?.call({'id': value.data['id'], 'polylines': value.data['polylines']});
            addDataToVisibleList(allZonesList, visibleZoneList);
            clearControllersAndVariables();
          }
        });
      } else {
        showSnackBar(message: lang_key.addAreaPolygon.tr, success: true);
      }
    }
  }

  /// Get zones list API call.
  void getAllZones() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(
        url: "${Urls.getAllZones}?limit=$limit&page=${currentPage.value}",
    ).then((value) {

      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        populateLists(allZonesList, value.data, visibleZoneList, (dynamic json) => ZoneModel.fromJson(json));
      }
    });
  }

  /// Change zone status to active or in-active.
  void changeZoneStatus(String id) {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.patchMethod(
        url: Urls.changeZoneStatus(id)
    ).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
      if(value.success!) {
        final allZoneListIndex = allZonesList.indexWhere((element) => element.id! == id);
        allZonesList[allZoneListIndex].status = !allZonesList[allZoneListIndex].status!;
        addDataToVisibleList(allZonesList, visibleZoneList);
      }
    });
  }

  /// Delete an existing zone
  void deleteZone(int index) {
    GlobalVariables.showLoader.value = true;
    
    ApiBaseHelper.deleteMethod(
        url: Urls.deleteZone(visibleZoneList[index].id.toString())
    ).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      allZonesList.removeWhere((element) => element.id == visibleZoneList[index].id);
      allZonesList.refresh();
      addDataToVisibleList(allZonesList, visibleZoneList);

    });
  }
  
  /// Clear controllers and variables associated with adding a new zone
  void clearControllersAndVariables() {
    enableAutoValidation.value = false;
    zoneNameController.clear();
    zoneDescController.clear();
    areaPolygons = '';
  }

  /// Search zone and update visible list.
  void searchInList(String? value) {
    if(value == '' || value == null || value.isEmpty) {
      addDataToVisibleList(allZonesList, visibleZoneList);
    } else {
      addDataToVisibleList(allZonesList.where((element) => element.name!.toLowerCase().trim().contains(value.toLowerCase().trim())).toList(), visibleZoneList);
    }
  }
}