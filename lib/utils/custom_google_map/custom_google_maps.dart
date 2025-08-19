@JS()
library;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
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
  final bool willDraw;
  final bool moveCamera;
  final double? latitude;
  final double? longitude;
  final double mapWidth;
  final double mapHeight;

  const GoogleMapWidget({
    super.key,
    required this.isBeingEdited,
    required this.mapController,
    this.willDraw = true,
    this.moveCamera = false,
    this.latitude,
    this.longitude,
    this.mapHeight = 280,
    this.mapWidth = double.infinity
  }) : assert((moveCamera && latitude != null && longitude != null) || (moveCamera == false && latitude == null && longitude == null), 'Provide latitude and longitude if you want to move the map camera.');

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late final String _mapDivId;
  late final String _viewType;
  late DrawingManager drawingManager;
  bool _mapReady = false;
  late GMap _gMap;

  Map<String, dynamic> polygonRefs = {};

  dynamic activePolygon;

  @override
  void initState() {
    super.initState();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _mapDivId = 'map-container-$timestamp';
    _viewType = 'google-map-view-$timestamp';
    const mapId = String.fromEnvironment('MAPS_ID');
    const mapKey = String.fromEnvironment('MAPS_API_KEY');

    _registerWebViewAndCallLoadingScript(mapKey, mapId);
  }

  html.Element _registerView(String mapId) {
    final container = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'relative';

    final mapDiv = html.DivElement()
      ..id = _mapDivId
      ..style.width = '100%'
      ..style.height = '100%';

    container.append(mapDiv);

    _gMap = GMap(
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
        _drawPolygons(_gMap);
      }
    };

    widget.mapController.updateZonePolygon = (Map<String, dynamic> zoneData) => updatePolygonData(zoneData);

    final rawMap = js_util.jsify(js_util.getProperty(_gMap, '__proto__') != null ? _gMap : js_util.getProperty(_gMap, 'map'));

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

    drawingManager.setMap(_gMap);

    _setGoogleMapVariables(rawMap);

    _drawUiButtons(rawMap, container, mapDiv);

    if(widget.moveCamera && widget.latitude != null && widget.longitude != null) {
      _moveCamera(_gMap, rawMap, moveToCustomLocation: true);
    }

    return container;
  }

  /// Move camera to the given location
  void _moveCamera(GMap map, dynamic rawMap, {bool moveToCustomLocation = false}) async {
    try{
      if(moveToCustomLocation) {
        map.panTo(ltln.LatLng(lat: widget.latitude!, lng: widget.longitude!));
      } else {
        final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();
        final position = await zoneListViewModel.determinePosition();
        map.panTo(ltln.LatLng(lat: position.latitude, lng: position.longitude));
      }
    } catch (e) {
      return;
    }
  }

  /// Make the polygon editable
  void _makeEditable(dynamic polygon, bool editable) {
    if (polygon == null) return;
    try {
      js_util.callMethod(polygon, 'setEditable', [editable]);
    } catch (_) {
      js_util.callMethod(polygon, 'setOptions', [js_util.jsify({'editable': editable})]);
    }
  }

  /// Function to draw polygon on the map
  void _drawPolygons(GMap gMap) {
    final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();
    final zones = zoneListViewModel.allZonesList;

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

  /// Function for updating, setting or removing polygons from Map
  void _addPathChangeListeners(dynamic path) {
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

  /// Draw UI buttons on the map
  void _drawUiButtons(dynamic rawMap, html.DivElement container, html.DivElement mapDiv) {
    if(widget.willDraw) {
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
        _moveCamera(_gMap, rawMap);
      });

      dragButton.onClick.listen((_) {
        drawingManager.setDrawingMode(null);
        mapDiv.style.pointerEvents = 'auto';
      });

      drawButton.onClick.listen((_) {
        final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();
        if (zoneListViewModel.areaPolygons != '') {
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

      final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();

      ever(zoneListViewModel.allZonesList, (_) {
        if(zoneListViewModel.allZonesList.isNotEmpty) {
          _drawPolygons(_gMap);
          cancelOperation();
        }
      });
    }
  }

  /// Cancel Adding new polygon
  void cancelOperation() {

    drawingManager.setDrawingMode(null);

    if (activePolygon != null) {
      js_util.callMethod(
          activePolygon, 'setMap', [null]);
      activePolygon = null;
      final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();
      zoneListViewModel.areaPolygons = '';
    }
  }

  /// This function is used to load the Google Maps script manually because the
  /// Google map is causing issue on Web.
  Future<void> loadGoogleMapsScript(String apiKey) async {
    if (js.context.hasProperty('google') &&
        js.context['google'].hasProperty('maps')) {
      return;
    }

    final completer = Completer<void>();

    final script = html.ScriptElement()
      ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey&libraries=drawing'
      ..async = true
      ..defer = true;

    script.onError.listen((_) {
      completer.completeError('Google Maps script load failed');
    });

    script.onLoad.listen((_) {
      completer.complete();
    });

    html.document.head!.append(script);
    return completer.future;
  }

  /// Calls the Google Map loading scripts and register web view
  void _registerWebViewAndCallLoadingScript(String mapKey, String mapId) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await loadGoogleMapsScript(mapKey);

        registerWebView(_viewType, (int viewId) => _registerView(mapId));

        if (mounted) {
          setState(() {
            _mapReady = true;
            if(widget.willDraw) Future.delayed(Duration(milliseconds: 500), () => _drawPolygons(_gMap));
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Google Maps script failed to load: $e');
        }
      }
    });
  }

  /// Update Polygon after zone is updated or edited.
  void updatePolygonData(Map<String, dynamic> zoneData) {
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
      'map': _gMap,
      'fillColor': '#c6c2c2',
      'fillOpacity': 0.4,
      'strokeWeight': 1.5,
      'clickable': false,
      'zIndex': 1,
    });

    final polygon = Polygon(polygonOptions);
    polygon.setMap(_gMap);
    polygonRefs[zoneId] = polygon;
  }

  /// Set the Google map variables like bounds, latlngConstructor, boundsConstructor
  /// etc and also set polygon data if we are either in the zone list or editing zone screen
  void _setGoogleMapVariables(dynamic rawMap) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.willDraw) {
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
            'map': _gMap,
            'editable': true,
            'fillColor': '#FF0000',
            'fillOpacity': 0.5,
            'strokeWeight': 1.5,
            'clickable': false,
            'zIndex': 1,
          });

          activePolygon = js_util.callConstructor(polygonConstructor, [polygonOptions]);
          final path = js_util.callMethod(activePolygon, 'getPath', []);
          _addPathChangeListeners(path);

          for (final c in cords) {
            final jsLatLng = js_util.callConstructor(latLngConstructor, [c.lat, c.lng]);
            js_util.callMethod(bounds, 'extend', [jsLatLng]);
          }

          js_util.callMethod(_gMap, 'fitBounds', [bounds]);
          drawingManager.setDrawingMode(null);
          drawingManager.setMap(null);
        } else {
          _moveCamera(_gMap, rawMap);
        }
        
        _setPolygonData();
      }
    });
  }

  /// Set Polygon data if we are either in the zone list or editing zone screen
  void _setPolygonData() {
    addListener(drawingManager, 'overlaycomplete', js.allowInterop((e) {
      if (activePolygon != null) {
        html.window.alert('Only one polygon is allowed.');
        return;
      }

      activePolygon = (e as OverlayCompleteEvent).overlay;
      _makeEditable(activePolygon, true);

      final path = js_util.callMethod(activePolygon, 'getPath', []);
      _addPathChangeListeners(path);
      final length = js_util.callMethod(path, 'getLength', []);
      final points = <String>[];

      for (var i = 0; i < length; i++) {
        final point = path.getAt(i);
        final lat = point.lat().toStringAsFixed(6);
        final lng = point.lng().toStringAsFixed(6);
        points.add('$lng $lat');

        if(i == length - 1) {
          points.add(points.first);
        }
      }

      final pointsString = points.join(', ');
      final polygonWKT = 'POLYGON(($pointsString))';

      if (widget.isBeingEdited) {
        Get.find<EditZoneViewModel>().areaPolygon = polygonWKT;
      } else {
        final zoneListViewModel = Get.find<ZoneListAndAdditionViewModel>();
        zoneListViewModel.areaPolygons = polygonWKT;
      }
      print(polygonWKT);
      drawingManager.setDrawingMode(null);
    }));
  }

  @override
  void dispose() {
    html.document.getElementById(_mapDivId)?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_mapReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.mapWidth,
      height: widget.mapHeight,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}