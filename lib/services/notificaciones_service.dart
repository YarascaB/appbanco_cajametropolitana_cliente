import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'session_service.dart';

class NotificacionesService {

  Future<List<dynamic>> obtener() async {

    final response = await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/notificaciones/${SessionService.userId}",
      ),
    );

    final data = jsonDecode(response.body);

    if (data["success"]) {

      return data["notificaciones"];
    }

    return [];
  }
}