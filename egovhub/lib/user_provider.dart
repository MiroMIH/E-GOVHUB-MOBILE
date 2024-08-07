import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId; // User ID
  String? get userId => _userId; // Getter for user ID

  void setUserId(String? userId) {
    _userId = userId;
    notifyListeners(); // Notify listeners when user ID changes
  }
}
