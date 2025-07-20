import '../models/caretakee_profile.dart';

class ProfileService {
  // Static list to store profiles during the session
  static List<CaretakeeProfile> _profiles = [];

  // Initialize mock data for caretakee profiles
  static List<CaretakeeProfile> _getInitialMockProfiles() {
    return [
      // Profiles for caretaker 1
      CaretakeeProfile(
        id: '1',
        caretakerId: '0EJxdR4GbvcP7N7Jdcr9oDn5vb83',
        name: 'Lucas',
        relationship: 'Younger Brother',
        age: 3,
      ),
      CaretakeeProfile(
        id: '2',
        caretakerId: '0EJxdR4GbvcP7N7Jdcr9oDn5vb83',
        name: 'Jonas',
        relationship: 'Older Brother',
        age: 5,
      ),
      CaretakeeProfile(
        id: '3',
        caretakerId: 'jC0Wnu9WETenlafrCRyhj7INlj63',
        name: 'Sophie Johnson',
        relationship: 'Mother',
        age: 65,
      ),
      // Profiles for caretaker 2 (different user)
      CaretakeeProfile(
        id: '4',
        caretakerId: 'jC0Wnu9WETenlafrCRyhj7INlj63',
        name: 'Emma Wilson',
        relationship: 'Daughter',
        age: 8,
      ),
      CaretakeeProfile(
        id: '5',
        caretakerId: 'jC0Wnu9WETenlafrCRyhj7INlj63',
        name: 'David Wilson',
        relationship: 'Father',
        age: 72,
      ),
    ];
  }

  // Get mock profiles (initialize if empty)
  static List<CaretakeeProfile> getMockProfiles() {
    if (_profiles.isEmpty) {
      _profiles = _getInitialMockProfiles();
    }
    return _profiles;
  }

  // Get all profiles (in future this could come from Firebase)
  static Future<List<CaretakeeProfile>> getProfiles() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockProfiles();
  }

  // Get profiles by caretaker ID
  static Future<List<CaretakeeProfile>> getProfilesByCaretakerId(
    String caretakerId,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final profiles = getMockProfiles();

    // If no profiles exist for this caretaker, create some default ones
    final userProfiles = profiles
        .where((profile) => profile.caretakerId == caretakerId)
        .toList();

    if (userProfiles.isEmpty) {
      // Create default profiles for this new user
      final defaultProfiles = _createDefaultProfilesForUser(caretakerId);
      _profiles.addAll(defaultProfiles);
      return defaultProfiles;
    }

    return userProfiles;
  }

  // Create default profiles for a new user
  static List<CaretakeeProfile> _createDefaultProfilesForUser(
    String caretakerId,
  ) {
    return [
      CaretakeeProfile(
        id: '${caretakerId}_1',
        caretakerId: caretakerId,
        name: 'Family Member',
        relationship: 'Family',
        age: 25,
      ),
      CaretakeeProfile(
        id: '${caretakerId}_2',
        caretakerId: caretakerId,
        name: 'Loved One',
        relationship: 'Close Friend',
        age: 30,
      ),
    ];
  }

  // Get profile by ID
  static CaretakeeProfile? getProfileById(String id) {
    final profiles = getMockProfiles();
    try {
      return profiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new profile (in future this will save to Firebase)
  static Future<bool> addProfile(CaretakeeProfile profile) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // Add the profile to our static list
      _profiles.add(profile);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create default profiles for a new caretaker
  static Future<void> createDefaultProfiles(String caretakerId) async {
    // This would typically create some starter profiles in Firebase
    // For now, it's just a placeholder
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
