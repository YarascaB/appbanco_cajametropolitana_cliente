import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class MisSolicitudesService {

  Future<List<dynamic>> obtenerSolicitudes(
    String userId,
  ) async {

    final response = await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/misSolicitudes/$userId",
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