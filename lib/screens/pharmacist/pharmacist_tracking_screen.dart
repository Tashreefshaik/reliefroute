import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../services/gps_service.dart';

class PharmacistTrackingScreen extends StatefulWidget {
  const PharmacistTrackingScreen({super.key});

  @override
  State<PharmacistTrackingScreen> createState() => _PharmacistTrackingScreenState();
}

class _PharmacistTrackingScreenState extends State<PharmacistTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Monitoring'),
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
              // Monitoring Panel
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
                    const Text(
                      'Active Deliveries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123047),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Delivery Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F8FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order #RR-2026-00421',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF123047),
                                ),
                              ),
                              _buildStatusChip(gpsService.deliveryStatus),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Color(0xFF087F8C), size: 20),
                              const SizedBox(width: 8),
                              const Text('Customer: Alex Morgan'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping, color: Color(0xFFB45309), size: 20),
                              const SizedBox(width: 8),
                              Text('Driver: ${gpsService.calculateDistance(gpsService.currentDriverLocation, GPSService.customerLocation).toStringAsFixed(1)} km away'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Progress
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Delivery Progress'),
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
                        ],
                      ),
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
                              // Contact driver
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Contacting driver...')),
                              );
                            },
                            icon: const Icon(Icons.message),
                            label: const Text('Contact'),
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

  double _calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }
}
