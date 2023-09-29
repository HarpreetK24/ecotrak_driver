import 'dart:math';

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);
}

double radians(double degrees) {
  return degrees * (pi / 180);
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  // Convert latitude and longitude from degrees to radians
  lat1 = radians(lat1);
  lon1 = radians(lon1);
  lat2 = radians(lat2);
  lon2 = radians(lon2);

  // Radius of the Earth in kilometers
  const double R = 6371;

  // Haversine formula
  final double dlon = lon2 - lon1;
  final double dlat = lat2 - lat1;
  final double a = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = R * c;

  return distance;
}

Coordinate findClosestCoordinate(
    List<Coordinate> coordinates, double userLat, double userLon) {
  double minDistance = double.infinity;
  Coordinate? closestCoordinate;

  for (final coordinate in coordinates) {
    final distance = calculateDistance(
        userLat, userLon, coordinate.latitude, coordinate.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      closestCoordinate = coordinate;
    }
  }

  return closestCoordinate!;
}

void main() {
  // Example user coordinates
  final userLat = 12.93626232871436;
  final userLon = 77.60621561694676;

  // Example set of coordinates
  final coordinates = [
    Coordinate(13.000000, 77.000000),
    Coordinate(12.900000, 77.100000),
    Coordinate(12.950000, 77.700000),
    // Add more coordinates as needed
  ];

  // Find the closest coordinate
  final closest = findClosestCoordinate(coordinates, userLat, userLon);

  print("Closest Coordinate: Lat ${closest.latitude}, Lon ${closest.longitude}");
}
