import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medication.dart';
import '../../services/firestore_service.dart';
import 'add_medication_screen.dart';

class MedicationManagementScreen extends StatefulWidget {
  const MedicationManagementScreen({super.key});

  @override
  State<MedicationManagementScreen> createState() => _MedicationManagementScreenState();
}

class _MedicationManagementScreenState extends State<MedicationManagementScreen> {
  List<Medication> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() => _isLoading = true);
    try {
      final medications = await context.read<FirestoreService>().getMedications();

      // Add mock data for demo
      if (medications.isEmpty) {
        setState(() {
          _medications = [
            Medication(
              medicationId: 'MED001',
              name: 'Amoxicillin 500mg',
              description: 'Antibiotic for bacterial infections. Take 1 capsule every 8 hours for 7 days.',
              price: 25.00,
              stockQty: 150,
              category: 'Antibiotics',
              prescriptionRequired: true,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED002',
              name: 'Ibuprofen 400mg',
              description: 'Pain reliever and anti-inflammatory. Take 1 tablet with food every 6-8 hours.',
              price: 49.99,
              stockQty: 300,
              category: 'Pain Relief',
              prescriptionRequired: false,
              imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951b55194?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED003',
              name: 'Lisinopril 10mg',
              description: 'Blood pressure medication. Take 1 tablet daily in the morning.',
              price: 89.00,
              stockQty: 100,
              category: 'Heart Health',
              prescriptionRequired: true,
              imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED004',
              name: 'Vitamin D3 1000IU',
              description: 'Vitamin supplement for bone health and immune support. Take 1 softgel daily.',
              price: 69.99,
              stockQty: 500,
              category: 'Vitamins',
              prescriptionRequired: false,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED005',
              name: 'Metformin 500mg',
              description: 'Diabetes medication. Take 1 tablet twice daily with meals.',
              price: 79.99,
              stockQty: 200,
              category: 'Diabetes',
              prescriptionRequired: true,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED006',
              name: 'Cetirizine 10mg',
              description: 'Allergy relief medication. Take 1 tablet daily for 24-hour relief.',
              price: 45.00,
              stockQty: 250,
              category: 'Allergy',
              prescriptionRequired: false,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED007',
              name: 'Aspirin 81mg',
              description: 'Low-dose aspirin for heart health. Take 1 tablet daily.',
              price: 35.00,
              stockQty: 400,
              category: 'Heart Health',
              prescriptionRequired: false,
              imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951b55194?w=200&h=200&fit=crop',
            ),
            Medication(
              medicationId: 'MED008',
              name: 'Omeprazole 20mg',
              description: 'Acid reflux medication. Take 1 capsule before breakfast.',
              price: 55.00,
              stockQty: 180,
              category: 'General',
              prescriptionRequired: false,
              imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
            ),
          ];
          _isLoading = false;
        });
      } else {
        setState(() {
          _medications = medications;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading medications: $e')),
        );
      }
    }
  }

  Future<void> _deleteMedication(String medicationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: const Text('Are you sure you want to delete this medication?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<FirestoreService>().deleteMedication(medicationId);
        _loadMedications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Medication deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting medication: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Management'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _medications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No medications found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _medications.length,
                  itemBuilder: (context, index) {
                    final medication = _medications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Medication Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: medication.imageUrl != null
                                  ? Image.network(
                                      medication.imageUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.medication, size: 40, color: Colors.grey),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.medication, size: 40, color: Colors.grey),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Medication Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    medication.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    medication.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${medication.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (medication.prescriptionRequired)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Rx',
                                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Stock: ${medication.stockQty}',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMedication(medication.medicationId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationScreen(),
            ),
          ).then((_) => _loadMedications());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
