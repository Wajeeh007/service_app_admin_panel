import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';

/// Colors

const primaryWhite = Colors.white;
const primaryBlack = Colors.black;
const primaryBlue = Color(0xff0059B3);
const panelBackground = Color(0xfff6f6f6);
const primaryDullYellow = Color(0xffe4b61a);
const errorRed = Colors.red;
Color primaryGrey = Colors.grey.shade400;
Color secondaryGrey = Colors.grey.shade200;
Color primaryGrey20 = primaryGrey.withValues(alpha: 0.2);
Color primaryGrey50 = primaryGrey.withValues(alpha: 0.5);

/// Container Decorations
  /// Border Radius
  BorderRadius kContainerBorderRadius = BorderRadius.circular(12);

  /// Border
  Border kContainerBorderSide = Border.all(
    color: primaryGrey.withValues(alpha: 0.5),
    width: 0.8
  );

  /// Standard Container BoxDecoration
  BoxDecoration kContainerBoxDecoration = BoxDecoration(
    color: primaryWhite,
    borderRadius: kContainerBorderRadius,
    border: kContainerBorderSide
  );
/// Container Decorations End ///

/// Constant Paddings ///
const EdgeInsets basePaddingForScreens = EdgeInsets.all(20);
const EdgeInsets basePaddingForContainers = EdgeInsets.all(20);
/// Constant Paddings End ///

/// Input Decorations ///
OutlineInputBorder kEnabledBorder = OutlineInputBorder(
  borderRadius: kContainerBorderRadius,
  borderSide: BorderSide(
    color: primaryGrey50,
    width: 0.8
  )
);

OutlineInputBorder kFocusedBorder = kEnabledBorder.copyWith(
  borderSide: kEnabledBorder.borderSide.copyWith(
    width: 1.5
  )
);

OutlineInputBorder kErrorBorder = kEnabledBorder.copyWith(
  borderSide: kEnabledBorder.borderSide.copyWith(
    color: errorRed
  )
);

OutlineInputBorder kFocusedErrorBorder = kFocusedBorder.copyWith(
  borderSide: kFocusedBorder.borderSide.copyWith(
    color: errorRed
  )
);

/// Input Decorations End ///

/// Google Maps constant values ///
CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(43.651774, -79.384573),
  zoom: mapsZoomLevel
);

double mapsZoomLevel = 14.0;
/// Google Maps constant values End ///

/// Order Status Enum
enum OrderStatus {pending, accepted, ongoing, completed, cancelled, dispute}
/// Order Status Enum End ///

/// New Method Input Field Type ///
enum NewMethodFieldType {text, number, email}
/// New Method Input Field Type End ///

/// Months list
const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

/// Sidepanel animation variables
Duration sidePanelAnimationDuration = Duration(milliseconds: 300);
Curve sidePanelAnimationCurve = Curves.easeIn;

/// Sidepanel scroll positions
List<Map<String, double>> sidePanelScrollPositions = [
  {'dashboard': 0.0}, {'zoneSetup': 90}, {'ordersManagement': 170},
  {'customerManagement': 260}, {'serviceManManagement': 390}, {'serviceManagement': GlobalVariables.scrollController.position.maxScrollExtent},
  {'withdraws': GlobalVariables.scrollController.position.maxScrollExtent}, {'settings': GlobalVariables.scrollController.position.maxScrollExtent}
];