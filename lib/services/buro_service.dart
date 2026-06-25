import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class BuroService {

  Future<Map<String, dynamic>?> obtenerBuro(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/buro/$userId",
        ),
      );

      final data =
          jsonDecode(response.body);

      if (data["success"] == true) {

        return data;
      }

      return null;

    } catch (e) {

      return null;
    }
  }
}