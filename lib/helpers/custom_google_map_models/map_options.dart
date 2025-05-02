import 'package:js/js.dart';

import 'lat_lng.dart';

@JS()
@anonymous
class MapOptions {
  external factory MapOptions({
    LatLng center,
    num zoom,
    bool clickableIcons,
    dynamic styles,
  });

  external LatLng get center;
  external num get zoom;
  external bool get clickableIcons;
  external dynamic get styles;
}