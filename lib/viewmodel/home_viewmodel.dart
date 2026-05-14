import 'package:flutter/material.dart';
import '../model/user_model.dart';

class HomeViewModel extends ChangeNotifier {
  UserModel usuario = UserModel(
    nombre: "Jairo Yarasca",
    saldo: 4580.50,
    deuda: 1200.00,
  );
}