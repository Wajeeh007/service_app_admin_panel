import 'package:js/js.dart';

@JS()
@anonymous
class LatLng {
  external factory LatLng({num lat, num lng});
  external num lat();
  external num lng();
}