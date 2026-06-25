import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'session_service.dart';

class AuthService {

  Future<String?> login({

    required String email,
    required String password,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(
          "${ApiService.baseUrl}/api/auth/login",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "email": email,
          "password": password,

        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

            print("LOGIN RESPONSE:");
            print(data);

            SessionService.userId =
                data["usuario"]["id"];

            print("USER ID: ${SessionService.userId}");

        SessionService.userId =
            data["usuario"]["id"];

        SessionService.nombre =
            data["usuario"]["nombre"];

        SessionService.email =
            data["usuario"]["email"];

        SessionService.rol =
            data["usuario"]["rol"];

        return null;
      }

      return data["message"];

    } catch (e) {

      return e.toString();
    }
  }

    Future<String?> register({
  required String nombre,
  required String apellido,
  required String email,
  required String password,
}) async {

  try {

    final response = await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/auth/register",
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return null;
    }

    return data["message"] ?? "Error al registrar usuario";

  } catch (e) {
    return e.toString();
  }
}

  Future<String?> resetPassword(
    String email,
  ) async {

    return "Recuperación aún no implementada";
  }

  Future<void> logout() async {

    SessionService.userId = null;
    SessionService.nombre = null;
    SessionService.email = null;
    SessionService.rol = null;
  }
}