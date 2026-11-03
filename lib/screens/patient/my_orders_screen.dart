import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../services/firestore_service.dart';
import '../../services/gps_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/order_timeline.dart';
import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Get actual user ID from auth service
      final orders = await context.read<FirestoreService>().getUserOrders('demo_user_id');

      // Add mock data with trackable status
      if (orders.isEmpty) {
        setState(() {
          _orders = [
            Order(
              orderId: 'ORD-2026-001',
              userId: 'demo_user_id',
              totalAmount: 189.99,
              status: 'processing',
              orderDate: DateTime.now(),
            ),
            Order(
              orderId: 'ORD-2026-002',
              userId: 'demo_user_id',
              totalAmount: 49.99,
              status: 'shipped',
              orderDate: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            Order(
              orderId: 'ORD-2026-003',
              userId: 'demo_user_id',
              totalAmount: 79.99,
              status: 'delivered',
              orderDate: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ];
          _isLoading = false;
        });
      } else {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No orders yet',
                  subtitle: 'Start shopping to see your orders here',
                )
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ExpansionTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('Order #${order.orderId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${order.orderDate.toString().split('.')[0]}',
                            ),
                            Text(
                              'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: _buildStatusChip(order.status),
                        children: [
                          OrderTimeline(currentStatus: order.status),
                          const SizedBox(height: 16),
                          if (order.status == 'shipped' || order.status == 'processing')
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<GPSService>().startDeliverySimulation();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrderTrackingScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.location_on),
                              label: const Text('Track Order'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF087F8C),
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.blue;
        break;
      case 'processing':
        color = Colors.purple;
        break;
      case 'shipped':
        color = Colors.indigo;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status.toUpperCase()),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
