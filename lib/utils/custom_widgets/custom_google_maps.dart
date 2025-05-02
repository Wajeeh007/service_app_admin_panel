@JS()
library;

import 'dart:async';

import 'package:get/get.dart';
import 'package:js/js.dart';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_viewmodel.dart';

import '../custom_google_map_libraries/drawing_manager.dart';
import '../custom_google_map_libraries/g_map.dart';
import '../custom_google_map_libraries/lat_lng.dart' as ltln;
import '../custom_google_map_libraries/map_options.dart';
import '../custom_google_map_libraries/marker.dart';
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

      const mapId = String.fromEnvironment('MAPS_ID');

      final map = GMap(
          mapDiv,
          MapOptions(
            center: ltln.LatLng(
                lat: initialCameraPosition.target.latitude,
                lng: initialCameraPosition.target.longitude
            ),
            zoom: mapsZoomLevel,
            clickableIcons: false,
            mapId: mapId,
          )
      );

      final drawingManager = DrawingManager(
          DrawingManagerOptions(
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
          )
      );

      AdvancedMarkerElement? userMarker;

      moveCamera(map, userMarker);

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
        viewModel.areaPolygons = points.join(', ');
        drawingManager.setDrawingMode(null);
      }));

      final dragButton = html.ButtonElement()
        ..text = '🧭'
        ..style.position = 'absolute'
        ..style.top = '10px'
        ..style.right = '140px'
        ..style.zIndex = '5';

      final drawButton = html.ButtonElement()
        ..text = '✏️'
        ..style.position = 'absolute'
        ..style.top = '10px'
        ..style.right = '100px'
        ..style.zIndex = '5';

      final locateButton = html.ButtonElement()
        ..text = '📍'
        ..style.position = 'absolute'
        ..style.top = '10px'
        ..style.right = '60px'
        ..style.zIndex = '5';

      locateButton.onClick.listen((_) {
        moveCamera(map, userMarker);
      });

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
      container.append(locateButton);

      return container;
    });
  }

  void moveCamera(GMap map, AdvancedMarkerElement? userMarker) {

    ZoneSetupViewModel viewModel = Get.find();

    viewModel.determinePosition().then((value) {
      map.panTo(ltln.LatLng(lat: value.latitude, lng: value.longitude));
      if (userMarker != null) {
        userMarker = null;
      }

      html.HtmlElement createBlueDot() {
        final dot = html.DivElement()
          ..style.width = '12px'
          ..style.height = '12px'
          ..style.borderRadius = '50%'
          ..style.backgroundColor = '#4285F4'
          ..style.border = '2px solid white'
          ..style.boxShadow = '0 0 6px rgba(66,133,244,0.6)';
        return dot;
      }

      userMarker = AdvancedMarkerElement(jsify({
        'position': ltln.LatLng(lat: value.latitude, lng: value.longitude),
        'map': map,
        'content': createBlueDot(),
        'title': 'Your Location',
      }));

    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 280,
      child: HtmlElementView(viewType: 'google-map-view'),
    );
  }
}