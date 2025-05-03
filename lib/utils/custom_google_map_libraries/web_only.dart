import 'package:web/web.dart' as html;
import 'dart:ui_web' as ui;

void registerWebView(String viewType, html.Element Function(int) viewFactory) {

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewType, viewFactory);

}
