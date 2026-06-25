import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/user_service.dart';

class HomeViewModel extends ChangeNotifier {

  final UserService _userService =
      UserService();

  UserModel? usuario;

  bool loading = false;

  Future<void> cargarUsuario(
    String userId,
  ) async {

    loading = true;

    notifyListeners();

    usuario =
        await _userService
            .obtenerUsuario(
      userId,
    );

    loading = false;

    notifyListeners();
  }
}