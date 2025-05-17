@JS()
library;

import 'package:get/get.dart';
import 'package:js/js.dart';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:service_app_admin_panel/screens/zone_setup/edit_zone/edit_zone_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_list_and_addition/zone_list_and_addition_viewmodel.dart';

import '../custom_google_map_libraries/drawing_manager.dart';
import '../custom_google_map_libraries/g_map.dart';
import '../custom_google_map_libraries/lat_lng.dart' as ltln;
import '../custom_google_map_libraries/map_options.dart';
import '../custom_google_map_libraries/overlay_complete.dart';
import '../custom_google_map_libraries/web_only.dart';

class GoogleMapWidget extends StatelessWidget {
  final String _viewType = 'google-map-view';

  final bool isBeingEdited;

  GoogleMapWidget({super.key, required this.isBeingEdited}) {

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

        final gMap = GMap(
            mapDiv,
            MapOptions(
              center: ltln.LatLng(
                  lat: initialCameraPosition.target.latitude,
                  lng: initialCameraPosition.target.longitude),
              zoom: mapsZoomLevel,
              mapId: mapId,
            ));

        final rawMap = js_util.jsify(js_util.getProperty(gMap, '__proto__') != null ? gMap : js_util.getProperty(gMap, 'map'));

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

        drawingManager.setMap(gMap);

        dynamic activePolygon;

        final EditZoneViewModel editZoneViewModel = Get.put(EditZoneViewModel());
        final ZoneListAndAdditionViewModel zoneListAndAdditionViewModel = Get.find();

        if(isBeingEdited) {

          final cords = editZoneViewModel.areaPolygon
              .split(',')
              .map((s) {
            final parts = s.trim().split(' ');
            return ltln.LatLng(
                lat: double.parse(parts[1]), lng: double.parse(parts[0]));
          }).toList();

          final google = js_util.getProperty(html.window, 'google');
          final maps = js_util.getProperty(google, 'maps');
          final polygonConstructor = js_util.getProperty(maps, 'Polygon');
          final latLngConstructor = js_util.getProperty(maps, 'LatLng');
          final latLngBoundsConstructor = js_util.getProperty(maps, 'LatLngBounds');
          final bounds = js_util.callConstructor(latLngBoundsConstructor, []);

          final polygonOptions = js_util.jsify({
            'paths': cords
                .map((c) => js_util.jsify({'lat': c.lat, 'lng': c.lng}))
                .toList(),
            'map': gMap,
            'editable': true,
            'fillColor': '#FF0000',
            'fillOpacity': 0.5,
            'strokeWeight': 1.5,
            'clickable': false,
            'zIndex': 1,
          });

          activePolygon = js_util.callConstructor(polygonConstructor, [polygonOptions]);

          for (final c in cords) {
            final jsLatLng = js_util.callConstructor(latLngConstructor, [c.lat, c.lng]);
            js_util.callMethod(bounds, 'extend', [jsLatLng]);
          }

          js_util.callMethod(gMap, 'fitBounds', [bounds]);

          drawingManager.setDrawingMode(null);
          drawingManager.setMap(null);
        }

        if(!isBeingEdited){
        moveCamera(gMap, rawMap);
      }

      addListener(drawingManager, 'overlaycomplete', allowInterop((e) {
          if (activePolygon != null) {
            html.window.alert('Only one polygon is allowed.');
            return;
          }

          activePolygon = (e as OverlayCompleteEvent).overlay;
          makeEditable(activePolygon, true);

          final path = js_util.callMethod(activePolygon, 'getPath', []);
          final length = js_util.callMethod(path, 'getLength', []);
          final points = <String>[];

          for (var i = 0; i < length; i++) {
            final point = path.getAt(i);
            final lat = point.lat();
            final lng = point.lng();
            points.add('$lng $lat');
          }

          if (points.first != points.last) {
            points.add(points.first);
          }

          if(isBeingEdited) {
            Get.find<EditZoneViewModel>().areaPolygon = points.join(', ');
          } else {
            zoneListAndAdditionViewModel.areaPolygons = points.join(', ');
          }
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
          moveCamera(gMap, rawMap);
        });

        dragButton.onClick.listen((_) {
          drawingManager.setDrawingMode(null);
          mapDiv.style.pointerEvents = 'auto';
        });

        drawButton.onClick.listen((_) {
          if (zoneListAndAdditionViewModel.areaPolygons != '') {
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

  void moveCamera(GMap map, dynamic rawMap) async {
    ZoneListAndAdditionViewModel viewModel = Get.find();

    viewModel.determinePosition().then((value) async {
      map.panTo(ltln.LatLng(lat: value.latitude, lng: value.longitude));
    });
  }

  void makeEditable(dynamic polygon, bool editable) {
    if (polygon == null) return;
    try {
      js_util.callMethod(polygon, 'setEditable', [editable]);
    } catch (_) {
      js_util.callMethod(polygon, 'setOptions', [js_util.jsify({'editable': editable})]);
    }
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