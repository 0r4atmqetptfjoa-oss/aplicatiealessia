import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

/// A simple service for managing the current user profile.
class UserProfileService extends ChangeNotifier {
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;

  void setCurrentUser(UserProfile profile) {
    _currentUser = profile;
    notifyListeners();
  }
}