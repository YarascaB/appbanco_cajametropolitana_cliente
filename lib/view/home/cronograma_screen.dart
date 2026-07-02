import 'package:flutter/material.dart';

import '../../model/installment_model.dart';
import '../../services/credit_service.dart';
import '../../services/session_service.dart';
import '../../ui/theme/app_colors.dart';

class CronogramaScreen extends StatelessWidget {
  const CronogramaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Cronograma"),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<InstallmentModel>>(
        future: CreditService().obtenerCronograma(
          SessionService.userId!,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No existe cronograma para este crédito",
              ),
            );
          }

          final cuotas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cuotas.length,
            itemBuilder: (context, index) {
              final cuota = cuotas[index];

              Color color;

              switch (cuota.estado.toLowerCase()) {
                case "pagado":
                  color = Colors.green;
                  break;

                case "vencido":
                  color = Colors.red;
                  break;

                default:
                  color = Colors.orange;
              }

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      cuota.numeroCuota.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    "Cuota ${cuota.numeroCuota}",
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Monto: S/. ${cuota.monto}",
                      ),
                      Text(
                        "Vence: ${cuota.fechaVencimiento}",
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      cuota.estado.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
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