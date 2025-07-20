import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medicine_reminder.dart';

class MedicineReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collection = 'medicine_reminders';

  // Test Firestore connectivity
  Future<void> testFirestoreConnection() async {
    try {
      print('Testing Firestore connection...');
      print('Current user: ${_auth.currentUser?.uid}');

      // Try to write a test document
      await _firestore.collection('test_collection').doc('test_doc').set({
        'message': 'Test from Flutter',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
      });

      print('✅ Write test successful');

      // Try to read the test document
      DocumentSnapshot doc = await _firestore
          .collection('test_collection')
          .doc('test_doc')
          .get();
      print('✅ Read test successful: ${doc.exists}');

      // Clean up
      await _firestore.collection('test_collection').doc('test_doc').delete();
      print('✅ Firestore is working properly');
    } catch (e) {
      print('❌ Firestore test failed: $e');
      throw e;
    }
  }

  // Add a new medicine reminder
  Future<String> addMedicineReminder(MedicineReminder reminder) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Adding medicine reminder for profile: ${reminder.profileId}');

      DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(reminder.toJson());

      print('Medicine reminder added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding medicine reminder: $e');
      throw Exception('Failed to add medicine reminder: $e');
    }
  }

  // Get all medicine reminders for a profile
  Future<List<MedicineReminder>> getMedicineReminders(String profileId) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Getting medicine reminders for profile: $profileId');

      // First try without orderBy to avoid index issues
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('profileId', isEqualTo: profileId)
          .get();

      print('Found ${querySnapshot.docs.length} medicine reminders');

      List<MedicineReminder> reminders = querySnapshot.docs
          .map((doc) {
            try {
              return MedicineReminder.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              });
            } catch (e) {
              print('Error parsing reminder document ${doc.id}: $e');
              return null;
            }
          })
          .where((reminder) => reminder != null)
          .cast<MedicineReminder>()
          .toList();

      // Sort manually by createdAt descending
      reminders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return reminders;
    } catch (e) {
      print('Error getting medicine reminders: $e');
      throw Exception('Failed to get medicine reminders: $e');
    }
  }

  // Update a medicine reminder
  Future<void> updateMedicineReminder(MedicineReminder reminder) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(reminder.id)
          .update(reminder.toJson());
    } catch (e) {
      throw Exception('Failed to update medicine reminder: $e');
    }
  }

  // Delete a medicine reminder
  Future<void> deleteMedicineReminder(String reminderId) async {
    try {
      await _firestore.collection(_collection).doc(reminderId).delete();
    } catch (e) {
      throw Exception('Failed to delete medicine reminder: $e');
    }
  }

  // Get active medicine reminders for today
  Future<List<MedicineReminder>> getActiveMedicineReminders(
    String profileId,
  ) async {
    try {
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);
      DateTime endOfDay = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
      );

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('profileId', isEqualTo: profileId)
          .where('startDate', isLessThanOrEqualTo: endOfDay)
          .where('endDate', isGreaterThanOrEqualTo: startOfDay)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => MedicineReminder.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get active medicine reminders: $e');
    }
  }
}
