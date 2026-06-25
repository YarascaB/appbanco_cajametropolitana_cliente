import 'package:flutter/material.dart';

import '../../../model/installment_model.dart';

import '../../../services/credit_service.dart';

class CreditDetailScreen
    extends StatelessWidget {

  final String userId;

  const CreditDetailScreen({

    super.key,

    required this.userId,
  });

  @override
  Widget build(BuildContext context) {

    final service =
        CreditService();

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Cronograma",
        ),
      ),

      body: FutureBuilder<

          List<InstallmentModel>>(

        future:
            service.obtenerCronograma(
          userId,
        ),

        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(

              child:
                  CircularProgressIndicator(),
            );
          }

          final cuotas =
              snapshot.data!;

          if (cuotas.isEmpty) {

            return const Center(

              child: Text(
                "No hay cuotas",
              ),
            );
          }

          return ListView.builder(

            itemCount:
                cuotas.length,

            itemBuilder:
                (context, index) {

              final cuota =
                  cuotas[index];

              final pagado =
                  cuota.estado ==
                      "pagado";

              return ListTile(

                leading: CircleAvatar(

                  backgroundColor:

                      pagado

                          ? Colors.green

                          : Colors.orange,

                  child: Icon(

                    pagado

                        ? Icons.check

                        : Icons.schedule,

                    color:
                        Colors.white,
                  ),
                ),

                title: Text(

                  "Cuota ${cuota.numeroCuota}",
                ),

                subtitle: Text(

                  cuota
                      .fechaVencimiento,
                ),

                trailing: Text(

                  "S/. ${cuota.monto}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}