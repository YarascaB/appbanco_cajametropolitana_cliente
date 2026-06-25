import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../../services/solicitud_credito_service.dart';
import '../../ui/theme/app_colors.dart';

class SolicitudCreditoScreen extends StatefulWidget {
  const SolicitudCreditoScreen({super.key});

  @override
  State<SolicitudCreditoScreen> createState() =>
      _SolicitudCreditoScreenState();
}

class _SolicitudCreditoScreenState
    extends State<SolicitudCreditoScreen> {

  final montoController =
      TextEditingController();

  final plazoController =
      TextEditingController();

  final propositoController =
      TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(

        backgroundColor:
            AppColors.primary,

        title: const Text(
          "Solicitar Crédito",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: montoController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText: "Monto",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: plazoController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Plazo (meses)",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  propositoController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Propósito",
              ),
            ),

            const SizedBox(height: 35),

            ElevatedButton(

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    AppColors.primary,

                minimumSize:
                    const Size(
                  double.infinity,
                  55,
                ),
              ),

              onPressed: loading
                  ? null
                  : registrarSolicitud,

              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Enviar Solicitud",
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registrarSolicitud() async {

    setState(() {
      loading = true;
    });

    final ok =
        await SolicitudCreditoService()
            .crearSolicitud(

      userId:
          SessionService.userId!,

      monto: double.parse(
        montoController.text,
      ),

      plazoMeses: int.parse(
        plazoController.text,
      ),

      proposito:
          propositoController.text,
    );

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    if (ok) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("Solicitud enviada"),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("Error al registrar"),
        ),
      );
    }
  }
}