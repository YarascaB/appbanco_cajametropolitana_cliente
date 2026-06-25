import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class ClientDetailService {

  Future<Map<String, dynamic>?> obtenerCliente(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/clientes/$userId",
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return data["cliente"];
      }

      return null;

    } catch (e) {

      print(e);

      return null;
    }
  }
}