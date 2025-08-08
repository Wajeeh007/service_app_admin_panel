import 'dart:html' as html;
import 'dart:ui_web' as ui;

void registerWebView(String viewType, html.Element Function(int viewId) viewFactory) {

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewType, viewFactory);

}
