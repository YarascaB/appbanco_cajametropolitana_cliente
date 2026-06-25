import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../../services/notificaciones_service.dart';

class NotificacionesScreen
    extends StatelessWidget {

  const NotificacionesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Notificaciones",
        ),
      ),

      body: FutureBuilder(

        future:
            NotificacionesService()
                .obtener(
          SessionService.userId!,
        ),

        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final lista =
              snapshot.data!;

          return ListView.builder(

            itemCount:
                lista.length,

            itemBuilder:
                (context, index) {

              final n =
                  lista[index];

              return ListTile(

                leading: Icon(

                  n["leida"] == true
                      ? Icons.notifications_none
                      : Icons.notifications,

                ),

                title:
                    Text(n["titulo"]),

                subtitle:
                    Text(n["mensaje"]),
              );
            },
          );
        },
      ),
    );
  }
}