import 'package:js/js.dart';

import 'lat_lng.dart';
import 'map_options.dart';

@JS('google.maps.Map')
class GMap {
  external GMap(dynamic mapDiv, MapOptions options);
  external void panTo(LatLng latLng);
}
