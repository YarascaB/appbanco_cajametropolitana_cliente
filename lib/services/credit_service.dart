import 'dart:convert';

import 'package:http/http.dart'
    as http;

import '../model/installment_model.dart';

import 'api_service.dart';

class CreditService {

  Future<List<InstallmentModel>>
      obtenerCronograma(
    String userId,
  ) async {

    try {

      final response =
          await http.get(

        Uri.parse(

          "${ApiService.baseUrl}/api/cronograma/$userId",
        ),
      );

      if (response.statusCode ==
          200) {

        final List data =
            jsonDecode(
          response.body,
        );

        return data

            .map(

              (item) =>
                  InstallmentModel
                      .fromJson(
                item,
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