import 'package:flutter/material.dart';

import '../../services/historial_solicitudes_service.dart';
import '../../services/session_service.dart';
import '../../ui/theme/app_colors.dart';

class HistorialSolicitudesScreen
    extends StatelessWidget {

  const HistorialSolicitudesScreen({
    super.key,
  });

  Color estadoColor(String estado) {

    switch (estado.toLowerCase()) {

      case "aprobado":
        return Colors.green;

      case "rechazado":
        return Colors.red;

      case "desembolsado":
        return Colors.blue;

      case "pendiente":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  IconData estadoIcon(String estado) {

    switch (estado.toLowerCase()) {

      case "aprobado":
        return Icons.check_circle;

      case "rechazado":
        return Icons.cancel;

      case "desembolsado":
        return Icons.account_balance_wallet;

      case "pendiente":
        return Icons.access_time;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        backgroundColor: AppColors.primary,

        title: const Text(
          "Historial de Solicitudes",
        ),
      ),

      body: FutureBuilder<List<dynamic>>(

        future:
            HistorialSolicitudesService()
                .obtener(
          SessionService.userId!,
        ),

        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {

            return const Center(

              child: Text(

                "No tienes solicitudes registradas",

                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }

          final solicitudes =
              snapshot.data!;

          return ListView.builder(

            padding:
                const EdgeInsets.all(15),

            itemCount:
                solicitudes.length,

            itemBuilder:
                (context, index) {

              final s =
                  solicitudes[index];

              final estado =
                  s["estado"] ?? "";

              return Card(

                elevation: 4,

                margin:
                    const EdgeInsets.only(
                  bottom: 15,
                ),

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Padding(

                  padding:
                      const EdgeInsets.all(
                    15,
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Row(

                        children: [

                          Icon(

                            estadoIcon(
                              estado,
                            ),

                            color:
                                estadoColor(
                              estado,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(

                            child: Text(

                              "Solicitud de Crédito",

                              style:
                                  const TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 18,
                              ),
                            ),
                          ),

                          Container(

                            padding:
                                const EdgeInsets.symmetric(

                              horizontal: 12,

                              vertical: 6,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  estadoColor(
                                estado,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),

                            child: Text(

                              estado
                                  .toUpperCase(),

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        "Monto: S/. ${s["monto"]}",
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        "Plazo: ${s["plazo_meses"]} meses",
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        "Propósito: ${s["proposito"] ?? "-"}",
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        "Fecha: ${s["created_at"] ?? "-"}",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}