import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;
import '../models/medication.dart';
import '../models/prescription.dart';
import '../models/order.dart' as app_order;
import '../models/order_item.dart';
import '../models/delivery.dart';
import '../models/driver.dart';
import '../models/refill_reminder.dart';

class FirestoreService extends ChangeNotifier {
  FirebaseFirestore? _firestore;
  bool _useMock = false;

  FirestoreService() {
    try {
      _firestore = FirebaseFirestore.instance;
      _firestore!.settings;
    } catch (e) {
      print('Firestore not available, using mock data: $e');
      _useMock = true;
      _firestore = null;
    }
  }

  Future<void> createUser(app_user.User user) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('users').doc(user.userId).set(user.toJson());
  }

  Future<app_user.User?> getUser(String userId) async {
    if (_useMock || _firestore == null) return null;
    final doc = await _firestore!.collection('users').doc(userId).get();
    if (doc.exists) {
      return app_user.User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(app_user.User user) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('users').doc(user.userId).update(user.toJson());
  }

  Future<List<Medication>> getMedications() async {
    if (_useMock || _firestore == null) {
      return _getMockMedications();
    }
    final snapshot = await _firestore!.collection('medications').get();
    return snapshot.docs.map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<Medication?> getMedication(String medicationId) async {
    if (_useMock || _firestore == null) return null;
    final doc = await _firestore!.collection('medications').doc(medicationId).get();
    if (doc.exists) {
      return Medication.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addMedication(Medication medication) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('medications').add(medication.toJson());
  }

  Future<void> updateMedication(Medication medication) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('medications').doc(medication.medicationId).update(medication.toJson());
  }

  Future<void> deleteMedication(String medicationId) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('medications').doc(medicationId).delete();
  }

  Future<void> addPrescription(Prescription prescription) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('prescriptions').add(prescription.toJson());
  }

  Future<Prescription?> getPrescription(String prescriptionId) async {
    if (_useMock || _firestore == null) return null;
    final doc = await _firestore!.collection('prescriptions').doc(prescriptionId).get();
    if (doc.exists) {
      return Prescription.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Prescription>> getUserPrescriptions(String userId) async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('prescriptions').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Prescription.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Prescription>> getPendingPrescriptions() async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('prescriptions').where('status', isEqualTo: 'pending').get();
    return snapshot.docs.map((doc) => Prescription.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updatePrescriptionStatus(String prescriptionId, String status, String? verifiedBy) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('prescriptions').doc(prescriptionId).update({
      'status': status,
      'verifiedBy': verifiedBy,
      'verifiedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> createOrder(app_order.Order order) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('orders').add(order.toJson());
  }

  Future<app_order.Order?> getOrder(String orderId) async {
    if (_useMock || _firestore == null) return null;
    final doc = await _firestore!.collection('orders').doc(orderId).get();
    if (doc.exists) {
      return app_order.Order.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<app_order.Order>> getUserOrders(String userId) async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('orders').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => app_order.Order.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> addOrderItem(OrderItem orderItem) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('orderItems').add(orderItem.toJson());
  }

  Future<List<OrderItem>> getOrderItems(String orderId) async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('orderItems').where('orderId', isEqualTo: orderId).get();
    return snapshot.docs.map((doc) => OrderItem.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> createDelivery(Delivery delivery) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('deliveries').add(delivery.toJson());
  }

  Future<Delivery?> getDelivery(String deliveryId) async {
    if (_useMock || _firestore == null) return null;
    final doc = await _firestore!.collection('deliveries').doc(deliveryId).get();
    if (doc.exists) {
      return Delivery.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<Delivery?> getDeliveryByOrder(String orderId) async {
    if (_useMock || _firestore == null) return null;
    final snapshot = await _firestore!.collection('deliveries').where('orderId', isEqualTo: orderId).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return Delivery.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Delivery>> getDriverDeliveries(String driverId) async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('deliveries').where('driverId', isEqualTo: driverId).get();
    return snapshot.docs.map((doc) => Delivery.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateDeliveryStatus(String deliveryId, String status) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('deliveries').doc(deliveryId).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> assignDriver(String deliveryId, String driverId) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('deliveries').doc(deliveryId).update({
      'driverId': driverId,
      'assignedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Driver>> getDrivers() async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('drivers').get();
    return snapshot.docs.map((doc) => Driver.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<Driver?> getDriver(String driverId) async {
    if (_useMock || _firestore == null) return null;
    final doc = await _firestore!.collection('drivers').doc(driverId).get();
    if (doc.exists) {
      return Driver.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addDriver(Driver driver) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('drivers').add(driver.toJson());
  }

  Future<void> updateDriverAvailability(String driverId, bool availability) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('drivers').doc(driverId).update({
      'available': availability,
    });
  }

  Future<void> addRefillReminder(RefillReminder reminder) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('refillReminders').add(reminder.toJson());
  }

  Future<List<RefillReminder>> getUserReminders(String userId) async {
    if (_useMock || _firestore == null) return [];
    final snapshot = await _firestore!.collection('refillReminders').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => RefillReminder.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateReminderStatus(String reminderId, bool active) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('refillReminders').doc(reminderId).update({
      'active': active,
    });
  }

  Future<void> updateReminderDate(String reminderId, DateTime newDate) async {
    if (_useMock || _firestore == null) return;
    await _firestore!.collection('refillReminders').doc(reminderId).update({
      'reminderDate': newDate.toIso8601String(),
    });
  }

  List<Medication> _getMockMedications() {
    return [
      Medication(
        medicationId: '1',
        name: 'Panado (Paracetamol)',
        description: 'Pain relief and fever reduction',
        price: 25.00,
        stockQty: 100,
        prescriptionRequired: false,
        category: 'Pain Relief',
      ),
      Medication(
        medicationId: '2',
        name: 'Aspirin',
        description: 'Pain relief, anti-inflammatory',
        price: 35.00,
        stockQty: 75,
        prescriptionRequired: false,
        category: 'Pain Relief',
      ),
      Medication(
        medicationId: '3',
        name: 'Amoxicillin',
        description: 'Antibiotic for bacterial infections',
        price: 85.00,
        stockQty: 50,
        prescriptionRequired: true,
        category: 'Antibiotics',
      ),
      Medication(
        medicationId: '4',
        name: 'Ibuprofen',
        description: 'Anti-inflammatory pain relief',
        price: 45.00,
        stockQty: 60,
        prescriptionRequired: false,
        category: 'Pain Relief',
      ),
      Medication(
        medicationId: '5',
        name: 'Cough Syrup',
        description: 'Relief for cough and sore throat',
        price: 55.00,
        stockQty: 40,
        prescriptionRequired: false,
        category: 'Cold & Flu',
      ),
    ];
  }
}
