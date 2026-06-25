import 'dart:convert';

import 'package:http/http.dart'
    as http;

import 'api_service.dart';

class TransferService {

  Future<String?> transferir({

    required String senderUserId,

    required String receiverEmail,

    required double monto,

  }) async {

    try {

      final response =
          await http.post(

        Uri.parse(

          "${ApiService.baseUrl}/api/transacciones/transferir",
        ),

        headers: {

          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "senderUserId":
              senderUserId,

          "receiverEmail":
              receiverEmail,

          "monto":
              monto,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return null;
      }

      return data["message"];

    } catch (e) {

      return e.toString();
    }
  }
}