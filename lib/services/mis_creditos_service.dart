import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class MisCreditosService {

  Future<Map<String,dynamic>?> obtenerCredito(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/mis-creditos/$userId",
        ),
      );

      final data =
          jsonDecode(response.body);

      if (data["success"] == true) {

        return data["credito"];
      }

      return null;

    } catch (_) {

      return null;
    }
  }
}