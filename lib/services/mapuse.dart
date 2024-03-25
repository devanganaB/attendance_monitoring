import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Function to get the current location of the faculty
Future<LatLng> getFacultyCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    print('Error getting faculty location: $e');
    throw Exception('Failed to get faculty location');
  }
}

// Function to get the current location of the student
Future<LatLng> getStudentCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    print('Error getting student location: $e');
    throw Exception('Failed to get student location');
  }
}

// Function to determine if the student's location is within a certain range of the faculty's location
Future<bool> isStudentWithinRange(
    LatLng studentLocation, LatLng facultyLocation, double maxDistance) async {
  try {
    double distance = await Geolocator.distanceBetween(
      facultyLocation.latitude,
      facultyLocation.longitude,
      studentLocation.latitude,
      studentLocation.longitude,
    );
    return distance <= maxDistance;
  } catch (e) {
    print('Error calculating distance: $e');
    throw Exception('Failed to calculate distance');
  }
}
