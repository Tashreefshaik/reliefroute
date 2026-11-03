import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../services/gps_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Order'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF123047),
        elevation: 0,
      ),
      body: Consumer<GPSService>(
        builder: (context, gpsService, _) {
          return Column(
            children: [
              // Map View
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: GPSService.pharmacyLocation,
                    zoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.reliefroute.reliefroute_app',
                    ),
                    // Route Line
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: gpsService.getRoutePoints(),
                          strokeWidth: 4.0,
                          color: const Color(0xFF087F8C),
                        ),
                      ],
                    ),
                    // Pharmacy Marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: GPSService.pharmacyLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.local_pharmacy,
                            color: Color(0xFF087F8C),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    // Customer Marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: GPSService.customerLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.home,
                            color: Color(0xFF15803D),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    // Driver Marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: gpsService.currentDriverLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.local_shipping,
                            color: Color(0xFFB45309),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123047),
                          ),
                        ),
                        _buildStatusChip(gpsService.deliveryStatus),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Progress'),
                            Text('${(gpsService.progress * 100).toInt()}%'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: gpsService.progress,
                          backgroundColor: const Color(0xFFE5F6F2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF087F8C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Estimated Time
                    _buildInfoRow(
                      Icons.access_time,
                      'Estimated Arrival',
                      _getEstimatedTime(gpsService.progress),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.directions_car,
                      'Driver Distance',
                      '${gpsService.calculateDistance(gpsService.currentDriverLocation, GPSService.customerLocation).toStringAsFixed(1)} km',
                    ),
                    const SizedBox(height: 16),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Simulate driver movement
                              final current = gpsService.currentDriverLocation;
                              final newLocation = LatLng(
                                current.latitude - 0.002,
                                current.longitude - 0.002,
                              );
                              gpsService.updateDriverPosition(newLocation);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF087F8C),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Call driver
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Calling driver...')),
                              );
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Call Driver'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF087F8C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status.toLowerCase()) {
      case 'assigned':
        color = const Color(0xFF64748B);
        label = 'Assigned';
        break;
      case 'picked_up':
        color = const Color(0xFFB45309);
        label = 'Picked Up';
        break;
      case 'in_transit':
        color = const Color(0xFF087F8C);
        label = 'In Transit';
        break;
      case 'delivered':
        color = const Color(0xFF15803D);
        label = 'Delivered';
        break;
      default:
        color = const Color(0xFF64748B);
        label = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF087F8C), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF123047),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getEstimatedTime(double progress) {
    if (progress >= 1.0) return 'Delivered';
    if (progress >= 0.8) return '5 min';
    if (progress >= 0.5) return '15 min';
    if (progress >= 0.3) return '25 min';
    return '35 min';
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }
}
