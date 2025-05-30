/// Extract coordinates in "lng lat, lng lat, ..... lng lat" format
String extractCoords(String polygon) {
  final regex = RegExp(r'POLYGON\s*\(\(\s*(.*?)\s*\)\)', caseSensitive: false);
  final match = regex.firstMatch(polygon);

  if (match == null) return '';

  final coordsString = match.group(1)!;

  final formattedCoords = coordsString.split(',')
      .map((pair) => pair.trim().replaceAll(RegExp(r'\s+'), ' ')).join(', ');

  return formattedCoords;
}

/// Convert coordinates to POLYGON((....)) format
String convertToWkt(String coords) {

  final cords = "POLYGON(($coords))";

  return cords;
}