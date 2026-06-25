import 'package:flutter/material.dart';

import '../../services/buro_service.dart';
import '../../services/session_service.dart';
import '../../ui/theme/app_colors.dart';

class BuroScreen extends StatelessWidget {

  const BuroScreen({super.key});

  String riesgo(double score) {

    if (score >= 80) {
      return "Bajo";
    }

    if (score >= 60) {
      return "Medio";
    }

    return "Alto";
  }

  Color riesgoColor(double score) {

    if (score >= 80) {
      return Colors.green;
    }

    if (score >= 60) {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        backgroundColor: AppColors.primary,

        title: const Text(
          "Buró Crediticio",
        ),
      ),

      body: FutureBuilder<Map<String, dynamic>?>(

        future: BuroService().obtenerBuro(
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
                "No existe información crediticia",
              ),
            );
          }

          final data = snapshot.data!;

          final scoreData =
              data["score"];

          final features =
              data["features"];

          final score =
              double.tryParse(
                    scoreData["score"]
                        .toString(),
                  ) ??
                  0;

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
                      const EdgeInsets.all(
                    25,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        riesgoColor(score),

                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),
                  ),

                  child: Column(

                    children: [

                      const Text(

                        "Score Crediticio",

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

                        score.toString(),

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontSize: 42,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        "Riesgo ${riesgo(score)}",

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                infoCard(
                  "Segmento",
                  scoreData["segmento"]
                          ?.toString() ??
                      "",
                ),

                infoCard(
                  "Recomendación",
                  scoreData["recomendacion"]
                          ?.toString() ??
                      "",
                ),

                infoCard(
                  "Monto Máximo Sugerido",
                  "S/. ${scoreData["monto_max_sugerido"]}",
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(

                  "Indicadores Financieros",

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
                  "Capacidad de Pago",
                  features["capacidad_pago"]
                          ?.toString() ??
                      "0",
                ),

                infoCard(
                  "Ratio Deuda / Ingreso",
                  features["ratio_deuda_ingreso"]
                          ?.toString() ??
                      "0",
                ),

                infoCard(
                  "Pagos Puntuales",
                  "${features["porcentaje_pagos_puntual"] ?? 0} %",
                ),

                infoCard(
                  "Saldo Promedio 3 Meses",
                  "S/. ${features["promedio_saldo_3m"] ?? 0}",
                ),

                infoCard(
                  "Frecuencia Transacciones",
                  features["frecuencia_transacciones"]
                          ?.toString() ??
                      "0",
                ),

                infoCard(
                  "Antigüedad (meses)",
                  features["antiguedad_meses"]
                          ?.toString() ??
                      "0",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget infoCard(
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
            BorderRadius.circular(
          20,
        ),
      ),

      child: ListTile(

        title: Text(titulo),

        subtitle: Text(valor),
      ),
    );
  }
}