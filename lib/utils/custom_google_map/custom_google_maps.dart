@JS()
library;

import 'dart:js_interop';

import 'package:get/get.dart';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:service_app_admin_panel/screens/zone_setup/edit_zone/edit_zone_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_list_and_addition/zone_list_and_addition_viewmodel.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/models_and_libraries/map_controller.dart';

import 'models_and_libraries/drawing_manager.dart';
import 'models_and_libraries/g_map.dart';
import 'models_and_libraries/lat_lng.dart' as ltln;
import 'models_and_libraries/map_options.dart';
import 'models_and_libraries/overlay_complete.dart';
import 'models_and_libraries/web_only.dart';

class GoogleMapWidget extends StatefulWidget {
  final bool isBeingEdited;
  final CustomGoogleMapController mapController;

  GoogleMapWidget({
    super.key,
    required this.isBeingEdited,
    required this.mapController
  });

  final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late final String _mapDivId;
  late final String _viewType;
  late DrawingManager drawingManager;

  Map<String, dynamic> polygonRefs = {};

  dynamic activePolygon;

  @override
  void initState() {
    super.initState();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _mapDivId = 'map-container-$timestamp';
    _viewType = 'google-map-view-$timestamp';

    registerWebView(_viewType, (int viewId) {
      final container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.position = 'relative';

      final mapDiv = html.DivElement()
        ..id = _mapDivId
        ..style.width = '100%'
        ..style.height = '100%';

      container.append(mapDiv);

      const mapId = String.fromEnvironment('MAPS_ID');

      final gMap = GMap(
        mapDiv,
        MapOptions(
          center: ltln.LatLng(
            lat: initialCameraPosition.target.latitude,
            lng: initialCameraPosition.target.longitude,
          ),
          zoom: mapsZoomLevel,
          mapId: mapId,
        ),
      );

      widget.mapController.addToPolygonRefs = (Map<String, dynamic> zoneData) {
        if(zoneData['id'] != null && (zoneData['polylines'] != null || zoneData['polylines'] != '')) {
          drawPolygons(gMap);
        }
      };

      widget.mapController.updateZonePolygon = (Map<String, dynamic> zoneData) {
        final zoneId = zoneData['id'];

        final oldPolygon = polygonRefs[zoneId];
        if (oldPolygon != null) {
          js_util.callMethod(oldPolygon, 'setMap', [null]);
          polygonRefs.remove(zoneId);
        }

        final coords = zoneData['polylines'].split(',').map((s) {
          final parts = s.trim().split(' ');
          return js_util.jsify({
            'lat': double.parse(parts[1]),
            'lng': double.parse(parts[0])
          });
        }).toList();

        final polygonOptions = js_util.jsify({
          'paths': coords,
          'map': gMap,
          'fillColor': '#c6c2c2',
          'fillOpacity': 0.4,
          'strokeWeight': 1.5,
          'clickable': false,
          'zIndex': 1,
        });

        final polygon = Polygon(polygonOptions);
        polygon.setMap(gMap);
        polygonRefs[zoneId] = polygon;
      };

      final rawMap = js_util.jsify(js_util.getProperty(gMap, '__proto__') != null ? gMap : js_util.getProperty(gMap, 'map'));

      drawingManager = DrawingManager(
          DrawingManagerOptions(
            drawingMode: null,
            drawingControl: false,
            polygonOptions: {
              'fillColor': '#FF0000',
              'fillOpacity': 0.5,
              'strokeWeight': 1.5,
              'clickable': false,
              'editable': true,
              'zIndex': 1,
            },
          )
      );

      drawingManager.setMap(gMap);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isBeingEdited) {
          final cords = Get.find<EditZoneViewModel>().areaPolygon.split(',').map((s) {
            final parts = s.trim().split(' ');
            return ltln.LatLng(
              lat: double.parse(parts[1]),
              lng: double.parse(parts[0]),
            );
          }).toList();

          final google = js_util.getProperty(html.window, 'google');
          final maps = js_util.getProperty(google, 'maps');
          final polygonConstructor = js_util.getProperty(maps, 'Polygon');
          final latLngConstructor = js_util.getProperty(maps, 'LatLng');
          final latLngBoundsConstructor = js_util.getProperty(maps, 'LatLngBounds');
          final bounds = js_util.callConstructor(latLngBoundsConstructor, []);

          final polygonOptions = js_util.jsify({
            'paths': cords.map((c) => js_util.jsify({'lat': c.lat, 'lng': c.lng})).toList(),
            'map': gMap,
            'editable': true,
            'fillColor': '#FF0000',
            'fillOpacity': 0.5,
            'strokeWeight': 1.5,
            'clickable': false,
            'zIndex': 1,
          });

          activePolygon = js_util.callConstructor(polygonConstructor, [polygonOptions]);
          final path = js_util.callMethod(activePolygon, 'getPath', []);
          addPathChangeListeners(path);

          for (final c in cords) {
            final jsLatLng = js_util.callConstructor(latLngConstructor, [c.lat, c.lng]);
            js_util.callMethod(bounds, 'extend', [jsLatLng]);
          }

          js_util.callMethod(gMap, 'fitBounds', [bounds]);
          drawingManager.setDrawingMode(null);
          drawingManager.setMap(null);
        } else {
          moveCamera(gMap, rawMap);
        }

        addListener(drawingManager, 'overlaycomplete', js.allowInterop((e) {
          if (activePolygon != null) {
            html.window.alert('Only one polygon is allowed.');
            return;
          }

          activePolygon = (e as OverlayCompleteEvent).overlay;
          makeEditable(activePolygon, true);

          final path = js_util.callMethod(activePolygon, 'getPath', []);
          addPathChangeListeners(path);
          final length = js_util.callMethod(path, 'getLength', []);
          final points = <String>[];

          for (var i = 0; i < length; i++) {
            final point = path.getAt(i);
            final lat = point.lat().toStringAsFixed(6);
            final lng = point.lng().toStringAsFixed(6);
            points.add('$lng $lat');
          }

          if (points.first != points.last) {
            points.add(points.first);
          }

          final pointsString = points.join(', ');

          if (widget.isBeingEdited) {
            Get.find<EditZoneViewModel>().areaPolygon = 'POLYGON(($pointsString))';
          } else {
            widget.zoneListViewModel.areaPolygons = 'POLYGON(($pointsString))';
          }

          drawingManager.setDrawingMode(null);
        }));
      });

      // UI Buttons
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

      final cancelButton = html.ButtonElement()
        ..text = '❌'
        ..style.position = 'absolute'
        ..style.top = '10px'
        ..style.right = '180px'
        ..style.zIndex = '5';

      cancelButton.onClick.listen((_) {
        cancelOperation();
      });

      locateButton.onClick.listen((_) {
        moveCamera(gMap, rawMap);
      });

      dragButton.onClick.listen((_) {
        drawingManager.setDrawingMode(null);
        mapDiv.style.pointerEvents = 'auto';
      });

      drawButton.onClick.listen((_) {
        if (widget.zoneListViewModel.areaPolygons != '') {
          html.window.alert('Only one polygon is allowed.');
          return;
        }
        drawingManager.setDrawingMode('polygon');
        mapDiv.style.pointerEvents = 'auto';
      });

      container.append(dragButton);
      container.append(drawButton);
      container.append(locateButton);
      if(!widget.isBeingEdited) container.append(cancelButton);

      ever(widget.zoneListViewModel.allZonesList, (_) {
        if(widget.zoneListViewModel.allZonesList.isNotEmpty) {
          drawPolygons(gMap);
          cancelOperation();
        }
      });

      return container;
    });
  }

  void moveCamera(GMap map, dynamic rawMap) async {
    try{
      final position = await widget.zoneListViewModel.determinePosition();
      map.panTo(ltln.LatLng(lat: position.latitude, lng: position.longitude));
    } catch (e) {
      return;
    }
  }

  void makeEditable(dynamic polygon, bool editable) {
    if (polygon == null) return;
    try {
      js_util.callMethod(polygon, 'setEditable', [editable]);
    } catch (_) {
      js_util.callMethod(polygon, 'setOptions', [js_util.jsify({'editable': editable})]);
    }
  }

  void drawPolygons(GMap gMap) {
    final zones = widget.zoneListViewModel.allZonesList;

    final currentZoneIds = zones.map((z) => z.id.toString()).toSet();
    final existingZoneIds = polygonRefs.keys.toSet();

    final removedIds = existingZoneIds.difference(currentZoneIds);

    for (final id in removedIds) {
      final polygon = polygonRefs[id];
      if (polygon != null) {
        js_util.callMethod(polygon, 'setMap', [null]);
        polygonRefs.remove(id);
      }
    }

    for (final zone in zones) {
      final id = zone.id.toString();
      if (polygonRefs.containsKey(id)) continue;

      final coords = zone.polylines!.split(',').map((s) {
        final parts = s.trim().split(' ');
        return js_util.jsify({
          'lat': double.parse(parts[1]),
          'lng': double.parse(parts[0]),
        });
      }).toList();

      final polygonOptions = js_util.jsify({
        'paths': coords,
        'map': gMap,
        'fillColor': '#c6c2c2',
        'fillOpacity': 0.4,
        'strokeWeight': 1.5,
        'clickable': false,
        'zIndex': 1,
      });

      final polygon = Polygon(polygonOptions);
      polygon.setMap(gMap);
      polygonRefs[id] = polygon;
    }
  }

  void addPathChangeListeners(dynamic path) {
    void updatePolygonString([dynamic a, dynamic b]) {
      final length = js_util.callMethod(path, 'getLength', []);
      final points = <String>[];

      for (var i = 0; i < length; i++) {
        final point = path.getAt(i);
        final lat = js_util.callMethod(point, 'lat', []);
        final lng = js_util.callMethod(point, 'lng', []);
        points.add('${lng.toStringAsFixed(6)} ${lat.toStringAsFixed(6)}');
      }

      if (points.isNotEmpty && points.first != points.last) {
        points.add(points.first);
      }

      final pointsString = points.join(', ');
      Get.find<EditZoneViewModel>().areaPolygon = 'POLYGON(($pointsString))';
    }

    addListener(path, 'set_at', js.allowInterop(updatePolygonString));
    addListener(path, 'insert_at', js.allowInterop(updatePolygonString));
    addListener(path, 'remove_at', js.allowInterop(updatePolygonString));
  }


  void cancelOperation() {

    drawingManager.setDrawingMode(null);

    if (activePolygon != null) {
      js_util.callMethod(
          activePolygon, 'setMap', [null]);
      activePolygon = null;
      widget.zoneListViewModel.areaPolygons = '';
    }

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 280,
      child: HtmlElementView(viewType: _viewType),
    );
  }

  @override
  void dispose() {
    html.document.getElementById(_mapDivId)?.remove();
    super.dispose();
  }
}