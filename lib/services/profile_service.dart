import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/caretakee_profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collection = 'caretakee_profiles';

  // Test Firestore connectivity
  Future<void> testFirestoreConnection() async {
    try {
      print('Testing Firestore connection from ProfileService...');
      print('Current user: ${_auth.currentUser?.uid}');

      // Try to write a test document
      await _firestore.collection('test_profiles').doc('test_profile').set({
        'message': 'Test profile from Flutter',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
      });

      print('✅ Profile service write test successful');

      // Try to read the test document
      DocumentSnapshot doc = await _firestore
          .collection('test_profiles')
          .doc('test_profile')
          .get();
      print('✅ Profile service read test successful: ${doc.exists}');

      // Clean up
      await _firestore.collection('test_profiles').doc('test_profile').delete();
      print('✅ Profile service Firestore is working properly');
    } catch (e) {
      print('❌ Profile service Firestore test failed: $e');
      rethrow;
    }
  }

  // Get all profiles for the current user
  Future<List<CaretakeeProfile>> getProfiles() async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      final caretakerId = _auth.currentUser!.uid;
      return await getProfilesByCaretakerId(caretakerId);
    } catch (e) {
      print('Error getting profiles: $e');
      throw Exception('Failed to get profiles: $e');
    }
  }

  // Get profiles by caretaker ID
  Future<List<CaretakeeProfile>> getProfilesByCaretakerId(
    String caretakerId,
  ) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Getting profiles for caretaker: $caretakerId');

      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('caretakerId', isEqualTo: caretakerId)
          .get();

      print('Found ${querySnapshot.docs.length} profiles');

      List<CaretakeeProfile> profiles = querySnapshot.docs
          .map((doc) {
            try {
              return CaretakeeProfile.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              });
            } catch (e) {
              print('Error parsing profile document ${doc.id}: $e');
              return null;
            }
          })
          .where((profile) => profile != null)
          .cast<CaretakeeProfile>()
          .toList();

      // If no profiles exist for this caretaker, create some default ones
      if (profiles.isEmpty && caretakerId == _auth.currentUser!.uid) {
        print('No profiles found, creating default profiles...');
        await createDefaultProfiles(caretakerId);
        // Recursively call to get the newly created profiles
        return await getProfilesByCaretakerId(caretakerId);
      }

      return profiles;
    } catch (e) {
      print('Error getting profiles by caretaker ID: $e');
      throw Exception('Failed to get profiles: $e');
    }
  }

  // Get profile by ID
  Future<CaretakeeProfile?> getProfileById(String id) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Getting profile by ID: $id');

      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!doc.exists) {
        print('Profile with ID $id not found');
        return null;
      }

      return CaretakeeProfile.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      print('Error getting profile by ID: $e');
      return null;
    }
  }

  // Add a new profile
  Future<String> addProfile(CaretakeeProfile profile) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Adding profile: ${profile.name}');

      final now = DateTime.now();

      // Create a copy without the id field since Firestore will generate it
      Map<String, dynamic> profileData = profile.toJson();
      profileData.remove('id');
      profileData['createdAt'] = now.toIso8601String();
      profileData['updatedAt'] = now.toIso8601String();

      DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(profileData);

      print('Profile added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding profile: $e');
      throw Exception('Failed to add profile: $e');
    }
  }

  // Update an existing profile
  Future<void> updateProfile(CaretakeeProfile profile) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Updating profile: ${profile.id}');

      // Create a copy without the id field
      Map<String, dynamic> profileData = profile.toJson();
      profileData.remove('id');
      profileData['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(_collection)
          .doc(profile.id)
          .update(profileData);

      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // Delete a profile
  Future<void> deleteProfile(String profileId) async {
    try {
      // Ensure user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      print('Deleting profile: $profileId');

      await _firestore.collection(_collection).doc(profileId).delete();

      print('Profile deleted successfully');
    } catch (e) {
      print('Error deleting profile: $e');
      throw Exception('Failed to delete profile: $e');
    }
  }

  // Create default profiles for a new caretaker
  Future<void> createDefaultProfiles(String caretakerId) async {
    try {
      print('Creating default profiles for caretaker: $caretakerId');

      final now = DateTime.now();
      List<Map<String, dynamic>> defaultProfiles = [
        {
          'caretakerId': caretakerId,
          'name': 'Family Member',
          'relationship': 'Family',
          'age': 25,
          'avatarUrl': null,
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
        {
          'caretakerId': caretakerId,
          'name': 'Loved One',
          'relationship': 'Close Friend',
          'age': 30,
          'avatarUrl': null,
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ];

      // Add each default profile
      for (Map<String, dynamic> profileData in defaultProfiles) {
        await _firestore.collection(_collection).add(profileData);
      }

      print('Default profiles created successfully');
    } catch (e) {
      print('Error creating default profiles: $e');
      throw Exception('Failed to create default profiles: $e');
    }
  }
}
