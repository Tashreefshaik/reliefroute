import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/firestore_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement getUsers in FirestoreService
      // Add mock data for demo
      setState(() {
        _users = [
          User(
            userId: 'user001',
            fullName: 'John Smith',
            email: 'john.smith@email.com',
            phone: '555-0101',
            role: 'patient',
            address: '123 Main St, New York, NY',
            imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
          ),
          User(
            userId: 'user002',
            fullName: 'Sarah Johnson',
            email: 'sarah.j@email.com',
            phone: '555-0102',
            role: 'patient',
            address: '456 Oak Ave, Brooklyn, NY',
            imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
          ),
          User(
            userId: 'pharm001',
            fullName: 'Dr. Emily Chen',
            email: 'emily.c@pharmacy.com',
            phone: '555-0201',
            role: 'pharmacist',
            address: '789 Pine Rd, Manhattan, NY',
            imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=100&h=100&fit=crop',
          ),
          User(
            userId: 'driver001',
            fullName: 'Mike Williams',
            email: 'mike.w@delivery.com',
            phone: '555-0301',
            role: 'driver',
            address: '321 Elm St, Queens, NY',
            imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop',
          ),
          User(
            userId: 'admin001',
            fullName: 'Admin User',
            email: 'admin@reliefroute.com',
            phone: '555-0001',
            role: 'admin',
            address: '100 Admin Blvd, NYC, NY',
            imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop',
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading users: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No users found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // User Avatar
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user.imageUrl != null
                                  ? NetworkImage(user.imageUrl!)
                                  : null,
                              child: user.imageUrl == null
                                  ? const Icon(Icons.person, size: 30)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            // User Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.phone,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildRoleChip(user.role),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add user dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add user feature coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role.toLowerCase()) {
      case 'patient':
        color = Colors.blue;
        break;
      case 'pharmacist':
        color = Colors.green;
        break;
      case 'driver':
        color = Colors.orange;
        break;
      case 'admin':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(role.toUpperCase()),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
