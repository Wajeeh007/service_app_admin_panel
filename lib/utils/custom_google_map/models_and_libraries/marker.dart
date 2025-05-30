@JS('google.maps.marker')
library;

import 'package:js/js.dart';

import 'lat_lng.dart';
// import '../lat_lng.dart';

@JS('google.maps.marker.AdvancedMarkerElement')
class AdvancedMarkerElement {
  external factory AdvancedMarkerElement(AdvancedMarkerOptions options);
}

@JS()
@anonymous
class AdvancedMarkerOptions {
  external factory AdvancedMarkerOptions({
    LatLng position,
    dynamic map, // must be raw JS map object
    dynamic content,
    String? title,
  });
}
