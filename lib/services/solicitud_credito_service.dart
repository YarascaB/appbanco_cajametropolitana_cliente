import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class SolicitudCreditoService {

  Future<bool> crearSolicitud({

    required String userId,
    required double monto,
    required int plazoMeses,
    required String proposito,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(
          "${ApiService.baseUrl}/api/solicitudes",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "user_id": userId,

          "monto": monto,

          "plazo_meses": plazoMeses,

          "tasa_anual": 18,

          "proposito": proposito,
        }),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        return true;
      }

      print(response.body);

      return false;

    } catch (e) {

      print(e);

      return false;
    }
  }
}