import 'package:js/js.dart';

import 'map_options.dart';

@JS('google.maps.Map')
class GMap {
  external GMap(dynamic mapDiv, MapOptions options);
}