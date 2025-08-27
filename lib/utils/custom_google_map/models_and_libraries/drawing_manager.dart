import 'package:js/js.dart';

@JS('google.maps.drawing.DrawingManager')
class DrawingManager {
  external DrawingManager(DrawingManagerOptions options);
  external void setMap(dynamic map);
  external void setDrawingMode(String? mode);
}

@JS()
@anonymous
class DrawingManagerOptions {
  external factory DrawingManagerOptions({
    dynamic drawingMode,
    dynamic drawingControl,
    List<String>? drawingControlOptions,
    dynamic polygonOptions,
    dynamic map,
  });
}