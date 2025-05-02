import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app_admin_panel/utils/constants.dart';

class ZoneSetupViewModel extends GetxController {

  /// Controller(s) & Global Key(s)
  TextEditingController zoneNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Variables for Google Maps ///
    /// Variable to store the location of device when location is fetched
    late LatLng currentCoordinates;

    /// Google Map Controller
    late GoogleMapController googleMapController;

    /// Maps loader
    RxBool showMapsLoader = false.obs;

    /// Polygons of an area
    String areaPolygons = '';

  /// Variables for Google Maps End ///
  @override
  void onReady() {
    _determinePosition();
    super.onReady();  
  }

  @override
  void onClose() {
    googleMapController.dispose();
    zoneNameController.dispose();
    super.onClose();
  }
  
  /// Fetch the current position of the device
  Future<void> _determinePosition() async {
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
    await Geolocator.getCurrentPosition(
      locationSettings: WebSettings(timeLimit: Duration(seconds: 20))
    ).then((value) {
      currentCoordinates = LatLng(value.latitude, value.longitude);
      googleMapCreated();
    }).catchError((error) {
      showMapsLoader.value = false;
    });
    // currentCoordinates.value = LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  /// Move Google Map to the given location when created
  Future<void> googleMapCreated() async {
    googleMapController.moveCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: currentCoordinates,
                zoom: mapsZoomLevel
            )
        )
    );
  }
}