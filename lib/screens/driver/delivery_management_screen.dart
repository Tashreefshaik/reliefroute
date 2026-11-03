import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/delivery.dart';
import '../../services/firestore_service.dart';

class DeliveryManagementScreen extends StatefulWidget {
  const DeliveryManagementScreen({super.key});

  @override
  State<DeliveryManagementScreen> createState() => _DeliveryManagementScreenState();
}

class _DeliveryManagementScreenState extends State<DeliveryManagementScreen> {
  List<Delivery> _deliveries = [];
  bool _isLoading = true;
  final Map<String, DateTime> _estimatedDeliveries = {
    'DEL001': DateTime.now().add(const Duration(hours: 2)),
    'DEL002': DateTime.now().add(const Duration(hours: 1)),
    'DEL003': DateTime.now().add(const Duration(minutes: 30)),
  };

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Get actual driver ID from auth service
      final deliveries = await context
          .read<FirestoreService>()
          .getDriverDeliveries('demo_driver_id');

      // Add mock data for demo
      if (deliveries.isEmpty) {
        setState(() {
          _deliveries = [
            Delivery(
              deliveryId: 'DEL001',
              orderId: 'ORD001',
              driverId: 'driver123',
              address: '123 Main Street, Apt 4B, New York, NY 10001',
              status: 'assigned',
            ),
            Delivery(
              deliveryId: 'DEL002',
              orderId: 'ORD002',
              driverId: 'driver123',
              address: '456 Oak Avenue, Suite 200, Brooklyn, NY 11201',
              status: 'picked_up',
            ),
            Delivery(
              deliveryId: 'DEL003',
              orderId: 'ORD003',
              driverId: 'driver123',
              address: '789 Pine Road, Queens, NY 11375',
              status: 'in_transit',
            ),
          ];
          _isLoading = false;
        });
      } else {
        setState(() {
          _deliveries = deliveries;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading deliveries: $e')),
        );
      }
    }
  }

  Future<void> _updateDeliveryStatus(Delivery delivery, String newStatus) async {
    try {
      await context.read<FirestoreService>().updateDeliveryStatus(
            delivery.deliveryId,
            newStatus,
          );
      _loadDeliveries();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delivery status updated to $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating delivery: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _deliveries.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No deliveries assigned',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for new deliveries',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _deliveries.length,
                itemBuilder: (context, index) {
                  final delivery = _deliveries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_shipping, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Delivery #${delivery.deliveryId}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Order ID: ${delivery.orderId}'),
                          const SizedBox(height: 4),
                          Text('Address: ${delivery.address}'),
                          const SizedBox(height: 4),
                          if (_estimatedDeliveries.containsKey(delivery.deliveryId))
                            Text(
                              'ETA: ${_formatDateTime(_estimatedDeliveries[delivery.deliveryId]!)}',
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                            ),
                          const SizedBox(height: 8),
                          _buildStatusChip(delivery.status),
                          const SizedBox(height: 16),
                          _buildStatusButtons(delivery),
                        ],
                      ),
                    ),
                  );
                },
              );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'assigned':
        color = Colors.blue;
        break;
      case 'picked_up':
        color = Colors.purple;
        break;
      case 'in_transit':
        color = Colors.indigo;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status.toUpperCase().replaceAll('_', ' ')),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildStatusButtons(Delivery delivery) {
    List<Widget> buttons = [];

    switch (delivery.status.toLowerCase()) {
      case 'assigned':
        buttons.add(
          ElevatedButton(
            onPressed: () => _updateDeliveryStatus(delivery, 'picked_up'),
            child: const Text('Mark as Picked Up'),
          ),
        );
        break;
      case 'picked_up':
        buttons.add(
          ElevatedButton(
            onPressed: () => _updateDeliveryStatus(delivery, 'in_transit'),
            child: const Text('Mark as In Transit'),
          ),
        );
        break;
      case 'in_transit':
        buttons.add(
          ElevatedButton(
            onPressed: () => _updateDeliveryStatus(delivery, 'delivered'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Mark as Delivered'),
          ),
        );
        break;
    }

    return Row(
      children: buttons,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ${difference.inMinutes % 60} min';
    } else {
      return '${difference.inDays} days';
    }
  }
}
