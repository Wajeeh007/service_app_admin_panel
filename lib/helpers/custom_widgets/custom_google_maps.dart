@JS()
library google_maps_interop;

import 'package:js/js.dart';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../web_only.dart';

@JS('google.maps.Map')
class GMap {
  external GMap(dynamic mapDiv, MapOptions options);
}

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

@JS()
@anonymous
class LatLng {
  external factory LatLng({num lat, num lng});
}

class GoogleMapWidget extends StatelessWidget {
  final String _viewType = 'google-map-view';

  GoogleMapWidget({super.key}) {
    // Register custom HTML view
    registerWebView(_viewType, (int viewId) {
      final elem = html.DivElement()
        ..id = 'map'
        ..style.width = '100%'
        ..style.height = '100%';

      // Map styles to hide POIs (optional)
      final mapStyles = [
        {
          'featureType': 'poi',
          'elementType': 'labels',
          'stylers': [
            {'visibility': 'off'}
          ]
        }
      ];

      GMap(elem, MapOptions(
        center: LatLng(lat: 37.7749, lng: -122.4194), // Example: San Francisco
        zoom: 13,
        clickableIcons: false,
        styles: mapStyles,
      ));

      return elem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 250,
      child: HtmlElementView(viewType: 'google-map-view'),
    );
  }
}
