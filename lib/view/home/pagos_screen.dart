import 'package:flutter/material.dart';

import '../../services/pagos_service.dart';
import '../../services/session_service.dart';
import '../../ui/theme/app_colors.dart';

class PagosScreen extends StatelessWidget {

  const PagosScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(

        backgroundColor:
            AppColors.primary,

        title:
            const Text("Mis Pagos"),
      ),

      body: FutureBuilder(

        future: PagosService()
            .obtenerPagos(
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
              snapshot.data == null) {

            return const Center(
              child:
                  Text("Sin pagos"),
            );
          }

          final data =
              snapshot.data!;

          final pagos =
              data["pagos"];

          return Column(

            children: [

              Container(

                margin:
                    const EdgeInsets.all(
                        20),

                padding:
                    const EdgeInsets.all(
                        20),

                decoration:
                    BoxDecoration(

                  color:
                      AppColors.primary,

                  borderRadius:
                      BorderRadius.circular(
                          25),
                ),

                child: Column(

                  children: [

                    const Text(

                      "Total Pagado",

                      style: TextStyle(
                        color:
                            Colors.white70,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    Text(

                      "S/. ${data["totalPagado"]}",

                      style:
                          const TextStyle(

                        color:
                            Colors.white,

                        fontSize: 32,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(

                      "${data["cantidad"]} pagos registrados",

                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(

                child: ListView.builder(

                  itemCount:
                      pagos.length,

                  itemBuilder:
                      (context, index) {

                    final pago =
                        pagos[index];

                    return Card(

                      margin:
                          const EdgeInsets
                              .symmetric(

                        horizontal: 20,
                        vertical: 8,
                      ),

                      child: ListTile(

                        leading:
                            const Icon(
                          Icons.payments,
                        ),

                        title: Text(
                          pago["servicio"]
                              .toString(),
                        ),

                        subtitle: Text(
                          pago["fecha"]
                              .toString(),
                        ),

                        trailing: Column(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            Text(

                              "S/. ${pago["monto"]}",

                              style:
                                  const TextStyle(

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            Text(
                              pago["estado"]
                                  .toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}