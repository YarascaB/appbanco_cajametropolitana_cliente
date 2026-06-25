import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class PagosService {

  Future<Map<String,dynamic>?> obtenerPagos(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/pagos/$userId",
        ),
      );

      final data =
          jsonDecode(response.body);

      if (data["success"] == true) {

        return data;
      }

      return null;

    } catch (_) {

      return null;
    }
  }
}