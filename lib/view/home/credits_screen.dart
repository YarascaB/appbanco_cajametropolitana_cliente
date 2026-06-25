import 'package:flutter/material.dart';

import '../../services/mis_creditos_service.dart';
import '../../services/session_service.dart';
import '../../ui/theme/app_colors.dart';

class CreditosScreen extends StatelessWidget {

  const CreditosScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        backgroundColor: AppColors.primary,

        title: const Text(
          "Mis Créditos",
        ),
      ),

      body: FutureBuilder<Map<String, dynamic>?>(

        future: MisCreditosService().obtenerCredito(
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
                "No tienes créditos registrados",
              ),
            );
          }

          final credito =
              snapshot.data!;

          return SingleChildScrollView(

            padding:
                const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    gradient:
                        const LinearGradient(

                      colors: [

                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(25),
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(

                        "Monto Aprobado",

                        style: TextStyle(

                          color:
                              Colors.white70,

                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(

                        "S/. ${credito["monto_preaprobado"] ??
                        credito["monto"]}",

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontSize: 36,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Container(

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: Text(

                          credito["estado"]
                              .toString()
                              .toUpperCase(),

                          style: const TextStyle(

                            color:
                                AppColors.primary,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(

                  "Detalle del Crédito",

                  style: TextStyle(

                    fontSize: 22,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                infoCard(
                  Icons.calendar_month,
                  "Plazo",
                  "${credito["plazo_meses"]} meses",
                ),

                infoCard(
                  Icons.payments,
                  "Cuota Mensual",
                  "S/. ${credito["cuota_estimada"] ??
                  credito["cuota_mensual"]}",
                ),

                infoCard(
                  Icons.percent,
                  "Tasa Mensual",
                  "${credito["tasa_mensual"] ??
                  credito["tasa_anual"]} %",
                ),

                infoCard(
                  Icons.analytics,
                  "Score Aprobación",
                  credito["score_aprobacion"]
                      .toString(),
                ),

                infoCard(
                  Icons.event_available,
                  "Vigente Hasta",
                  credito["vigente_hasta"] ??
                  credito["created_at"]
                      .toString(),
                ),

                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/cronograma",
                      );
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text("Ver Cronograma"),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/historialSolicitudes",
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text("Historial de Solicitudes"),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/timelineSolicitudes",
                      );
                    },
                    icon: const Icon(Icons.timeline),
                    label: const Text("Timeline de Solicitudes"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget infoCard(
    IconData icon,
    String titulo,
    String valor,
  ) {

    return Card(

      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: ListTile(

        leading: Icon(
          icon,
          color: AppColors.primary,
        ),

        title: Text(titulo),

        subtitle: Text(valor),
      ),
    );
  }
}