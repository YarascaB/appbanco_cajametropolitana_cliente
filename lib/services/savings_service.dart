import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class SavingsService {

  Future<Map<String, dynamic>?> obtenerCuenta(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/ahorros/$userId",
        ),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        return data;
      }

      return null;

    } catch (e) {

      print(e);

      return null;
    }
  }
}