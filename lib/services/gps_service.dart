import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class GPSService extends ChangeNotifier {
  // Simulated locations in South Africa
  static const LatLng pharmacyLocation = LatLng(-26.2041, 28.0473); // Johannesburg
  static const LatLng customerLocation = LatLng(-26.1952, 28.0342); // Nearby
  
  LatLng _currentDriverLocation = LatLng(-26.2100, 28.0600);
  String _deliveryStatus = 'assigned';
  double _progress = 0.0;

  LatLng get currentDriverLocation => _currentDriverLocation;
  String get deliveryStatus => _deliveryStatus;
  double get progress => _progress;

  // Simulate driver movement
  void startDeliverySimulation() {
    _deliveryStatus = 'in_transit';
    _progress = 0.25;
    notifyListeners();
  }

  void updateDriverPosition(LatLng newPosition) {
    _currentDriverLocation = newPosition;
    _progress = _calculateProgress();
    notifyListeners();
  }

  void updateStatus(String status) {
    _deliveryStatus = status;
    if (status == 'delivered') {
      _progress = 1.0;
    }
    notifyListeners();
  }

  double _calculateProgress() {
    // Simple distance-based progress calculation
    final totalDistance = _calculateDistance(pharmacyLocation, customerLocation);
    final currentDistance = _calculateDistance(_currentDriverLocation, customerLocation);
    return 1.0 - (currentDistance / totalDistance);
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  // Public method for external use
  double calculateDistance(LatLng start, LatLng end) {
    return _calculateDistance(start, end);
  }

  // Get route points for visualization
  List<LatLng> getRoutePoints() {
    return [
      pharmacyLocation,
      LatLng(-26.2070, 28.0550),
      LatLng(-26.2050, 28.0500),
      LatLng(-26.2000, 28.0450),
      LatLng(-26.1980, 28.0400),
      customerLocation,
    ];
  }
}
