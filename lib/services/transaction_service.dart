import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/transaction_model.dart';
import 'api_service.dart';

class TransactionService {

  Future<List<TransactionModel>>
      obtenerMovimientos(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/transacciones/$userId",
        ),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return (data["movimientos"] as List)

            .map(

              (e) =>
                  TransactionModel.fromJson(
                e,
              ),
            )

            .toList();
      }

      return [];

    } catch (e) {

      print(e);

      return [];
    }
  }
}