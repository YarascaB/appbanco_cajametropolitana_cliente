import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class AccountService {

  Future<double> obtenerSaldo(
    String userId,
  ) async {

    final response = await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/cuentas/saldo/$userId",
      ),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {

      return double.parse(
        data["saldo"].toString(),
      );
    }

    return 0;
  }
}