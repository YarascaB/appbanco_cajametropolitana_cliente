import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../../services/mis_solicitudes_service.dart';

class MisSolicitudesScreen extends StatelessWidget {

  const MisSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Mis Solicitudes",
        ),
      ),

      body: FutureBuilder(

        future:
            MisSolicitudesService()
                .obtenerSolicitudes(

          SessionService.userId!,
        ),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final solicitudes =
              snapshot.data!;

          return ListView.builder(

            itemCount:
                solicitudes.length,

            itemBuilder: (context, index) {

              final s =
                  solicitudes[index];

              return Card(

                margin:
                    const EdgeInsets.all(
                  10,
                ),

                child: ListTile(

                  title: Text(
                    "S/. ${s["monto"]}",
                  ),

                  subtitle: Text(
                    s["estado"],
                  ),

                  trailing: Text(
                    "${s["plazo_meses"]} meses",
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