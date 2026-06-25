import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/user_model.dart';
import 'api_service.dart';

class UserService {

  Future<UserModel?> obtenerUsuario(
    String userId,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ApiService.baseUrl}/api/clientes/$userId",
        ),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        final cliente =
            data["cliente"];

        return UserModel(

          uid: cliente["user_id"],

          nombre:
              "${cliente["nombres"]} ${cliente["apellidos"]}",

          dni:
              cliente["dni"] ?? "",

          email: "",

          saldo: 4500,

          deuda:
              double.tryParse(
                    cliente["deuda_actual"]
                        .toString(),
                  ) ??
                  0,
        );
      }

      return null;

    } catch (e) {

      print(e);

      return null;
    }
  }
}