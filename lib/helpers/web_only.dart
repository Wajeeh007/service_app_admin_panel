import 'dart:html' as html;
import 'dart:ui' as ui;

void registerWebView(String viewType, html.Element Function(int) viewFactory) {
  // Web-only registration
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewType, viewFactory);
}
