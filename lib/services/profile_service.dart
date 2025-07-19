import '../models/caretakee_profile.dart';

class ProfileService {
  // Mock data for caretakee profiles
  static List<CaretakeeProfile> getMockProfiles() {
    return [
      CaretakeeProfile(
        id: '1',
        name: 'Lucas',
        relationship: 'Younger Brother',
        age: 3,
      ),
      CaretakeeProfile(
        id: '2',
        name: 'Jonas',
        relationship: 'Older Brother',
        age: 5,
      ),
      CaretakeeProfile(
        id: '3',
        name: 'Sophie Johnson',
        relationship: 'Mother',
        age: 65,
      ),
    ];
  }

  // Get all profiles (in future this could come from Firebase)
  static Future<List<CaretakeeProfile>> getProfiles() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockProfiles();
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
}
