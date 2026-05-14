import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool loading = false;
  bool success = false;
  String error = '';

  final String usuarioCorrecto = "12345678";
  final String passwordCorrecto = "1234";

  void login(String usuario, String password) {
    loading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      if (usuario == usuarioCorrecto &&
          password == passwordCorrecto) {
        success = true;
        error = '';
      } else {
        success = false;
        error = 'Credenciales incorrectas';
      }

      loading = false;
      notifyListeners();
    });
  }
}