import 'package:js/js.dart';

import 'lat_lng.dart';

@JS()
@anonymous
class MapOptions {
  external LatLng get center;
  external num get zoom;
  external String? get mapId;

  external factory MapOptions({
    LatLng center,
    num zoom,
    String? mapId,
  });
}