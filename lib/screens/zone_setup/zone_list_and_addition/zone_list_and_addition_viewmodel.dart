import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:service_app_admin_panel/models/zone_model.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/helper_functions/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class ZoneListAndAdditionViewModel extends GetxController {

  /// Controller(s) & Global Key(s)
  TextEditingController zoneNameController = TextEditingController();
  TextEditingController zoneDescController = TextEditingController();
  TextEditingController zoneSearchController = TextEditingController();
  GlobalKey<FormState> zoneNameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> zoneSearchFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  /// Variables for Google Maps ///
    /// Maps loader
    RxBool showMapsLoader = false.obs;

    /// Polygons of an area
    String areaPolygons = '';

  /// Variables for Google Maps End ///

  /// Variable for page toggling
  RxInt currentPage = 0.obs;
  RxInt totalPages = 3.obs;

  /// Zone list page data
  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;

  /// Limit variables
  int limit = 10;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    getAllZones();
    animateSidePanelScrollController(
      scrollController,
        sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'zoneSetup').values.first);
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

  Future<void> loadGoogleMapsLibraries() async {
    final google = js_util.getProperty(js_util.globalThis, 'google');
    final maps = js_util.getProperty(google, 'maps');

    await js_util.promiseToFuture(
      js_util.callMethod(maps, 'importLibrary', ['maps']),
    );

    await js_util.promiseToFuture(
      js_util.callMethod(maps, 'importLibrary', ['marker']),
    );
  }

  /// Fetch the current position of the device
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    showMapsLoader.value = true;
    return await Geolocator.getCurrentPosition(
      locationSettings: WebSettings(timeLimit: Duration(seconds: 20), accuracy: LocationAccuracy.best)
    );
  }
  
  void addNewZone() {
    if(zoneNameFormKey.currentState!.validate()) {
      if(areaPolygons != '') {
        
        Map<String, dynamic> body = {
          'name': zoneNameController.text,
          'desc': zoneDescController.text,
          'polygon': areaPolygons
        };
        
        ApiBaseHelper.postMethod(
            url: Urls.addNewZone,
            body: body
        ).then((value) {
          if(value.success!) {
            stopLoaderAndShowSnackBar(lang_key.zoneCreated.tr, true);
            zoneList.add(ZoneModel.fromJson(value.data));
            zoneNameController.clear();
            areaPolygons = '';
          } else {
            stopLoaderAndShowSnackBar(value.message!, false);
          }
        });
      }
    }
  }

  /// Get zones list
  void getAllZones() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(
        url: "${Urls.getAllZones}?limit=$limit&page=${currentPage.value}",
    ).then((value) {
      if(value.success!) {
        GlobalVariables.showLoader.value = false;
        final data = value.data as List;
        zoneList.addAll(data.map((e) => ZoneModel.fromJson(e)));
        zoneList.refresh();
      } else {
        stopLoaderAndShowSnackBar(value.message!, true);
      }
    });
  }

  /// Change zone status to active or in-active.
  void changeZoneStatus(int index) {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.patchMethod(
        url: Urls.changeZoneStatus(zoneList[index].id.toString())
    ).then((value) {
      if(value.success!) {
        GlobalVariables.showLoader.value = false;
        zoneList[index].status = !zoneList[index].status!;
        zoneList.refresh();
      } else {
        stopLoaderAndShowSnackBar(value.message!, true);
      }
    });
  }
}