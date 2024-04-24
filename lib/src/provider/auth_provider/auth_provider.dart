import 'package:flutter/material.dart';

import '../../components/auth/login_page.dart';
import '../../components/home/home_page.dart';
import '../../models/authModel/auth_model.dart';
import '../../services/auth_services.dart';
import '../../utils/Local_Storage_Util.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userModel = await AuthService().login(email, password);

      _user = userModel;
      notifyListeners();

      await LocalStorageUtil.saveUserData(_user!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout(BuildContext context) {
    _user = null;
    LocalStorageUtil.clearUserData();
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
