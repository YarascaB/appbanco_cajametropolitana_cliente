import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../../services/solicitud_credito_service.dart';
import '../../ui/theme/app_colors.dart';
import 'dart:math';

class SolicitudCreditoScreen extends StatefulWidget {
  const SolicitudCreditoScreen({super.key});

  @override
  State<SolicitudCreditoScreen> createState() =>
      _SolicitudCreditoScreenState();
}

class _SolicitudCreditoScreenState extends State<SolicitudCreditoScreen> {

  double monto = 1000;
  double plazo = 12;

  final propositoController = TextEditingController();

  bool loading = false;

  // 💰 simulación tasa (puedes cambiarla luego por backend)
  double tasaInteres = 0.18;

 double get cuotaMensual {
  final tasaMensual = tasaInteres / 12;

  final numerador =
      monto * tasaMensual * pow(1 + tasaMensual, plazo);

  final denominador =
      pow(1 + tasaMensual, plazo) - 1;

  return numerador / denominador;
}

  double get probabilidadAprobacion {
    double score = 0;

    if (monto < 5000) score += 40;
    else if (monto < 15000) score += 25;
    else score += 10;

    if (plazo <= 12) score += 30;
    else if (plazo <= 24) score += 20;
    else score += 10;

    if (propositoController.text.isNotEmpty) score += 20;

    return score.clamp(0, 100);
  }

  Color getScoreColor(double value) {
    if (value >= 70) return Colors.green;
    if (value >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = probabilidadAprobacion;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Simulador de crédito"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _header(),

            const SizedBox(height: 20),

            _card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Monto solicitado",
          prefixIcon: Icon(Icons.attach_money),
        ),
        onChanged: (value) {
          setState(() {
            monto = double.tryParse(value) ?? 0;
          });
        },
      ),

      const SizedBox(height: 16),

      TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Plazo (meses)",
          prefixIcon: Icon(Icons.date_range),
        ),
        onChanged: (value) {
          setState(() {
            plazo = double.tryParse(value) ?? 0;
          });
        },
      ),
    ],
  ),
),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Resumen del crédito",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _row("Cuota mensual estimada",
                      "S/ ${cuotaMensual.toStringAsFixed(2)}"),

                  _row("Tasa de interés", "${(tasaInteres * 100).toStringAsFixed(0)}%"),

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 10),

                  TextField(
                    controller: propositoController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: "Propósito del crédito",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                children: [

                  const Text(
                    "Probabilidad de aprobación",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      getScoreColor(score),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${score.toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: getScoreColor(score),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Simula tu crédito",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Ajusta los valores y mira tu aprobación estimada",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          )
        ],
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  Widget _row(String a, String b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a),
          Text(
            b,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: loading ? null : registrarSolicitud,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Enviar solicitud"),
      ),
    );
  }

  Future<void> registrarSolicitud() async {
    setState(() => loading = true);

    final ok = await SolicitudCreditoService().crearSolicitud(
      userId: SessionService.userId!,
      monto: monto,
      plazoMeses: plazo.toInt(),
      proposito: propositoController.text,
    );

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? "Solicitud enviada" : "Error al registrar"),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) Navigator.pop(context);
  }
}