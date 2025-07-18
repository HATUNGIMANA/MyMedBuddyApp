import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _fullName;

  String? get username => _username;
  String? get fullName => _fullName;

  bool get isLoggedIn => _username != null && _fullName != null;

  void login(String username, String fullName) {
    _username = username;
    _fullName = fullName;
    notifyListeners();
  }

  void logout() {
    _username = null;
    _fullName = null;
    notifyListeners();
  }
} 
