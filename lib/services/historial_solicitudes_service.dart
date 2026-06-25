import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class HistorialSolicitudesService {

  Future<List<dynamic>> obtenerSolicitudes(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/historial-solicitudes/$userId",
        ),
      );

      final data =
          jsonDecode(response.body);

      if (data["success"] == true) {

        return data["solicitudes"];
      }

      return [];

    } catch (_) {

      return [];
    }
  }

  Future<List<dynamic>> obtener(
    String userId,
  ) async {

    final response = await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/solicitudes/cliente/$userId",
      ),
    );

    final data =
        jsonDecode(response.body);

    if (data["success"] == true) {

      return data["solicitudes"];
    }

    return [];
  }
}
