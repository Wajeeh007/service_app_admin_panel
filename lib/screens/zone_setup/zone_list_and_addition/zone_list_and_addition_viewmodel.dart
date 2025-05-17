import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:service_app_admin_panel/screens/zone_setup/zone_model.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';
// import 'dart:js_util' as js_util;

class ZoneListAndAdditionViewModel extends GetxController {

  /// Controller(s) & Global Key(s)
  TextEditingController zoneNameController = TextEditingController();
  TextEditingController zoneSearchController = TextEditingController();
  GlobalKey<FormState> zoneNameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> zoneSearchFormKey = GlobalKey<FormState>();

  /// Variables for Google Maps ///
    /// Maps loader
    RxBool showMapsLoader = false.obs;

    /// Polygons of an area
    String areaPolygons = '';

  /// Variables for Google Maps End ///

  /// Variable for page toggling
  RxInt currentPage = 1.obs;
  RxInt totalPages = 3.obs;

  /// Zone list page data
  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'zoneSetup').values.first);
    determinePosition();
    super.onReady();  
  }

  @override
  void onClose() {
    zoneNameController.dispose();
    zoneSearchController.dispose();
    detachSidePanelScrollController();
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
}