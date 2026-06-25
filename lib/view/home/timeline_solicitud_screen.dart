import 'package:flutter/material.dart';

import '../../services/timeline_service.dart';

class TimelineSolicitudesScreen
    extends StatelessWidget {

  const TimelineSolicitudesScreen({
    super.key,
  });

  Color obtenerColor(String estado) {

    switch (estado) {

      case "pendiente":
        return Colors.orange;

      case "aprobado":
        return Colors.blue;

      case "desembolsado":
        return Colors.green;

      case "rechazado":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Timeline Solicitud",
        ),
      ),

      body: FutureBuilder(

        future:
            TimelineService()
                .obtenerEstado(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final credito =
              snapshot.data!;

          final estado =
              credito["estado"];

          return Padding(

            padding:
                const EdgeInsets.all(20),

            child: Column(

              children: [

                etapa(
                  "Solicitud enviada",
                  true,
                  Colors.green,
                ),

                etapa(
                  "Evaluación",
                  estado != "pendiente",
                  Colors.blue,
                ),

                etapa(
                  "Aprobación",
                  estado == "aprobado" ||
                      estado ==
                          "desembolsado",
                  Colors.indigo,
                ),

                etapa(
                  "Desembolso",
                  estado ==
                      "desembolsado",
                  Colors.green,
                ),

                const SizedBox(
                  height: 30,
                ),

                Container(

                  padding:
                      const EdgeInsets.all(20),

                  decoration:
                      BoxDecoration(

                    color:
                        obtenerColor(
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

                      fontSize: 24,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget etapa(
    String titulo,
    bool activa,
    Color color,
  ) {

    return ListTile(

      leading: CircleAvatar(

        backgroundColor:
            activa
                ? color
                : Colors.grey,

        child: Icon(

          activa
              ? Icons.check
              : Icons.circle,

          color: Colors.white,
        ),
      ),

      title: Text(titulo),
    );
  }
}