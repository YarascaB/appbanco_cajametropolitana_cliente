import 'package:flutter/material.dart';

import '../../ui/theme/app_colors.dart';
import '../../services/savings_service.dart';
import '../../services/session_service.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Mis Cuentas"),
      ),

      backgroundColor: AppColors.background,

      body: FutureBuilder<Map<String, dynamic>?>(
        future: SavingsService().obtenerCuenta(
          SessionService.userId!,
        ),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null) {
            return const Center(
              child: Text(
                "No existe información",
              ),
            );
          }

          final cuenta =
              snapshot.data!["cuenta"];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                // CUENTA AHORROS

                accountCard(
                  "Cuenta de Ahorros",
                  "**** 4589",
                  "S/. ${cuenta["saldo"]}",
                ),

                const SizedBox(height: 25),

                // DETALLE CUENTA

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [

                      ListTile(
                        leading:
                            const Icon(Icons.flag),

                        title:
                            const Text(
                          "Meta de ahorro",
                        ),

                        subtitle: Text(
                          "S/. ${cuenta["meta_ahorro"]}",
                        ),
                      ),

                      ListTile(
                        leading:
                            const Icon(Icons.percent),

                        title:
                            const Text(
                          "Tasa de interés",
                        ),

                        subtitle: Text(
                          "${cuenta["tasa_interes"]} %",
                        ),
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.calendar_month,
                        ),

                        title: const Text(
                          "Fecha apertura",
                        ),

                        subtitle: Text(
                          cuenta["fecha_apertura"]
                              .toString()
                              .substring(0, 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // CUENTA CTS (DEMO)

                accountCard(
                  "Cuenta CTS",
                  "**** 9821",
                  "S/. 12000",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget accountCard(
    String title,
    String number,
    String amount,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(number),

          const SizedBox(height: 20),

          Text(
            amount,

            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}