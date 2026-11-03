import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medication.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';
import 'medication_detail_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Medication> _medications = [];
  List<Medication> _filteredMedications = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Pain Relief',
    'Antibiotics',
    'Vitamins',
    'Allergy',
    'Diabetes',
    'Heart Health',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _loadMedications();
    _searchController.addListener(_filterMedications);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMedications() async {
    setState(() => _isLoading = true);
    try {
      final medications = await context.read<FirestoreService>().getMedications();

      // Add mock data with images for demo
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
          _filteredMedications = _medications;
          _isLoading = false;
        });
      } else {
        setState(() {
          _medications = medications;
          _filteredMedications = medications;
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

  void _filterMedications() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedications = _medications.where((med) {
        final matchesSearch = med.name.toLowerCase().contains(query) ||
            med.description.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' ||
            med.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search medications...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                      _filterMedications();
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadMedications,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMedications.isEmpty
                    ? const EmptyState(
                        icon: Icons.medication_outlined,
                        title: 'No medications found',
                        subtitle: 'Try adjusting your search or check back later',
                      )
                    : ListView.builder(
                        itemCount: _filteredMedications.length,
                        itemBuilder: (context, index) {
                          final medication = _filteredMedications[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicationDetailScreen(
                                      medication: medication,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Medication Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
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
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE5F6F2),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: const Icon(Icons.medication, size: 40, color: Color(0xFF087F8C)),
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE5F6F2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(Icons.medication, size: 40, color: Color(0xFF087F8C)),
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
                                                'R${medication.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF087F8C),
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
                                              const Spacer(),
                                              Icon(
                                                medication.stockQty > 0 ? Icons.check_circle : Icons.cancel,
                                                color: medication.stockQty > 0 ? Colors.green : Colors.red,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${medication.stockQty} in stock',
                                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }
}
