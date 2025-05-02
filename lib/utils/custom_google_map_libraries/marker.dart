@JS('google.maps.marker')
library advanced_marker;

import 'package:js/js.dart';
import 'dart:html';
import 'lat_lng.dart';
import 'g_map.dart';

@JS('AdvancedMarkerElement')
class AdvancedMarkerElement {
  external factory AdvancedMarkerElement(AdvancedMarkerOptions options);
  external set map(GMap? map);
}

@JS()
@anonymous
class AdvancedMarkerOptions {
  external LatLng get position;
  external GMap get map;
  external HtmlElement? get content;
  external String? get title;

  external factory AdvancedMarkerOptions({
    required LatLng position,
    required GMap map,
    HtmlElement? content,
    String? title,
  });
}
