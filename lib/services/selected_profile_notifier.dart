import 'package:flutter/foundation.dart';
import '../models/caretakee_profile.dart';

class SelectedProfileNotifier extends ChangeNotifier {
  CaretakeeProfile? _selectedProfile;

  CaretakeeProfile? get selectedProfile => _selectedProfile;

  void setSelectedProfile(CaretakeeProfile? profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  void clearSelectedProfile() {
    _selectedProfile = null;
    notifyListeners();
  }
}

// Global instance
final selectedProfileNotifier = SelectedProfileNotifier();
