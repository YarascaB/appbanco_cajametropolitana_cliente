import 'dart:convert';

import 'package:http/http.dart'
    as http;

import 'api_service.dart';

class TransactionApiService {

  Future<String?> registrarPago({

    required String userId,
    required double monto,
    required String descripcion,

  }) async {

    try {

      final response =
          await http.post(

        Uri.parse(
          "${ApiService.baseUrl}/api/transacciones",
        ),

        headers: {
          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "userId": userId,

          "tipo": "debito",

          "descripcion":
              descripcion,

          "monto": monto,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return null;
      }

      return data["message"];

    } catch (e) {

      return e.toString();
    }
  }
}