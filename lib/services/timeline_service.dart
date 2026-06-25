import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'session_service.dart';

class TimelineService {

  Future<Map<String, dynamic>?> obtenerEstado() async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/mis-creditos/${SessionService.userId}",
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