import 'package:shared_preferences/shared_preferences.dart';
import '../models/authModel/auth_model.dart';

class LocalStorageUtil {
  static Future<void> saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', user.id);
      prefs.setString('userEmail', user.email);
      prefs.setString('userToken', user.token);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static Future<UserModel?> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userEmail = prefs.getString('userEmail');
      final userToken = prefs.getString('userToken');

      if (userId != null && userEmail != null && userToken != null) {
        return UserModel(id: userId, email: userEmail, token: userToken);
      } else {
        return null;
      }
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userId');
      prefs.remove('userEmail');
      prefs.remove('userToken');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }
}
