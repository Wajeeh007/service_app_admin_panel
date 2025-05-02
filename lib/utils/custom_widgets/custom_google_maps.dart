@JS()
library;

import 'package:get/get.dart';
import 'package:js/js.dart';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_viewmodel.dart';

import '../custom_google_map_libraries/drawing_manager.dart';
import '../custom_google_map_libraries/g_map.dart';
import '../custom_google_map_libraries/lat_lng.dart';
import '../custom_google_map_libraries/map_options.dart';
import '../custom_google_map_libraries/overlay_complete.dart';
import '../custom_google_map_libraries/web_only.dart';

class GoogleMapWidget extends StatelessWidget {
  final String _viewType = 'google-map-view';

  GoogleMapWidget({super.key}) {

    registerWebView(_viewType, (int viewId) {
      final container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.position = 'relative';

      final mapDiv = html.DivElement()
        ..id = 'map'
        ..style.width = '100%'
        ..style.height = '100%';

      container.append(mapDiv);

      final mapStyles = [
        {
          'featureType': 'poi',
          'elementType': 'labels',
          'stylers': [
            {'visibility': 'off'}
          ]
        }
      ];

      final map = GMap(mapDiv, MapOptions(
        center: LatLng(lat: initialCameraPosition.target.latitude, lng: initialCameraPosition.target.longitude),
        zoom: mapsZoomLevel,
        clickableIcons: false,
        styles: mapStyles,
      ));

      final drawingManager = DrawingManager(DrawingManagerOptions(
        drawingMode: null,
        drawingControl: false,
        polygonOptions: {
          'fillColor': '#FF0000',
          'fillOpacity': 0.5,
          'strokeWeight': 1.5,
          'clickable': false,
          'editable': true,
          'zIndex': 1
        },
      ));

      drawingManager.setMap(map);
      ZoneSetupViewModel viewModel = Get.find<ZoneSetupViewModel>();
      addListener(drawingManager, 'overlaycomplete', allowInterop((e) {

        if(viewModel.areaPolygons != '') {
          html.window.alert('Only one polygon is allowed.');
          return;
        }

        final event = e as OverlayCompleteEvent;
        final path = event.overlay.getPath();
        final points = <String>[];

        for (var i = 0; i < path.getLength(); i++) {
          final point = path.getAt(i);
          final lat = point.lat();
          final lng = point.lng();
          points.add('$lng $lat');
        }

        if (points.first != points.last) {
          points.add(points.first);
        }
        Get.find<ZoneSetupViewModel>().areaPolygons = points.join(', ');
        drawingManager.setDrawingMode(null);
      }));

      final dragButton = html.ButtonElement()
        ..text = '🧭 Drag'
        ..style.position = 'absolute'
        ..style.top = '10px'
        ..style.right = '130px'
        ..style.zIndex = '5';

      final drawButton = html.ButtonElement()
        ..text = '✏️ Draw'
        ..style.position = 'absolute'
        ..style.top = '10px'
        ..style.right = '60px'
        ..style.zIndex = '5';

      dragButton.onClick.listen((_) {
        drawingManager.setDrawingMode(null);
        mapDiv.style.pointerEvents = 'auto';
      });

      drawButton.onClick.listen((_) {
        if(viewModel.areaPolygons != '') {
          html.window.alert('Only one polygon is allowed.');
          return;
        }
        drawingManager.setDrawingMode('polygon');
        mapDiv.style.pointerEvents = 'auto';
      });

      container.append(dragButton);
      container.append(drawButton);

      return container;
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
