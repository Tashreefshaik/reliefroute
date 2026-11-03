import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/medication.dart';
import '../models/prescription.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/delivery.dart';
import '../models/driver.dart';
import '../models/refill_reminder.dart';

class FirestoreService extends ChangeNotifier {
  Future<void> createUser(User user) async {}
  Future<User?> getUser(String userId) async => null;
  Future<void> updateUser(User user) async {}
  Future<List<Medication>> getMedications() async => [];
  Future<Medication?> getMedication(String medicationId) async => null;
  Future<void> addMedication(Medication medication) async {}
  Future<void> updateMedication(Medication medication) async {}
  Future<void> deleteMedication(String medicationId) async {}
  Future<void> addPrescription(Prescription prescription) async {}
  Future<Prescription?> getPrescription(String prescriptionId) async => null;
  Future<List<Prescription>> getUserPrescriptions(String userId) async => [];
  Future<List<Prescription>> getPendingPrescriptions() async => [];
  Future<void> updatePrescriptionStatus(String prescriptionId, String status, String? verifiedBy) async {}
  Future<void> createOrder(Order order) async {}
  Future<Order?> getOrder(String orderId) async => null;
  Future<List<Order>> getUserOrders(String userId) async => [];
  Future<void> updateOrderStatus(String orderId, String status) async {}
  Future<void> addOrderItem(OrderItem orderItem) async {}
  Future<List<OrderItem>> getOrderItems(String orderId) async => [];
  Future<void> createDelivery(Delivery delivery) async {}
  Future<Delivery?> getDelivery(String deliveryId) async => null;
  Future<Delivery?> getDeliveryByOrder(String orderId) async => null;
  Future<List<Delivery>> getDriverDeliveries(String driverId) async => [];
  Future<void> updateDeliveryStatus(String deliveryId, String status) async {}
  Future<void> assignDriver(String deliveryId, String driverId) async {}
  Future<List<Driver>> getDrivers() async => [];
  Future<Driver?> getDriver(String driverId) async => null;
  Future<void> addDriver(Driver driver) async {}
  Future<void> updateDriverAvailability(String driverId, bool availability) async {}
  Future<void> addRefillReminder(RefillReminder reminder) async {}
  Future<List<RefillReminder>> getUserReminders(String userId) async => [];
  Future<void> updateReminderStatus(String reminderId, bool active) async {}
  Future<void> updateReminderDate(String reminderId, DateTime newDate) async {}
}
