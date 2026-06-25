import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class NotificacionesService {

  Future<List<dynamic>> obtener(
    String userId,
  ) async {

    final response = await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/notificaciones/$userId",
      ),
    );

    final data =
        jsonDecode(response.body);

    return data["notificaciones"] ?? [];
  }
}