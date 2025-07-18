import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveUser(String username, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_username', username);
    await prefs.setString('user_fullname', fullName);
  }

  static Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('user_username') ?? '';
    final fullName = prefs.getString('user_fullname') ?? '';
    return {'username': username, 'fullname': fullName};
  }

  static Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  static Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_path');
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
} 
