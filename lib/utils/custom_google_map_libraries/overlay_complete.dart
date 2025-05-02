import 'package:js/js.dart';

import 'lat_lng.dart';

@JS()
@anonymous
class OverlayCompleteEvent {
  external Polygon overlay;
}

@JS('google.maps.event.addListener')
external void addListener(dynamic instance, String eventName, Function callback);

@JS('google.maps.Polygon')
class Polygon {
  external MVCArray<LatLng> getPath();
}

@JS()
class MVCArray<T> {
  external int getLength();
  external T getAt(int i);
}