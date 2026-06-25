import 'package:flutter/material.dart';

import '../../ui/theme/app_colors.dart';
import '../../services/session_service.dart';
import '../../services/transaction_api_service.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final montoController = TextEditingController();
  final transactionService = TransactionApiService();

  bool loading = false;
  String? selectedService;

  final services = ["Luz", "Agua", "Internet"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔥 HEADER MODERNO
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text("Pagos"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _serviceSelector(),
              const SizedBox(height: 25),
              _amountInput(),
              const SizedBox(height: 25),
              _summaryCard(),
              const SizedBox(height: 30),
              _payButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// ⚡ SELECTOR TIPO CHIPS
  Widget _serviceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selecciona servicio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          children: services.map((s) {
            final selected = selectedService == s;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedService = s;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 💰 INPUT MODERNO
  Widget _amountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Monto a pagar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: montoController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Ej: 50.00",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.attach_money),
          ),
        ),
      ],
    );
  }

  /// 📄 RESUMEN
  Widget _summaryCard() {
    final monto = montoController.text;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Text("Servicio: ${selectedService ?? '-'}"),
          Text("Monto: S/. ${monto.isEmpty ? '0.00' : monto}"),
        ],
      ),
    );
  }

  /// 🚀 BOTÓN PRO
  Widget _payButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),

        onPressed: loading
            ? null
            : () async {
                if (selectedService == null ||
                    montoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Completa los datos"),
                    ),
                  );
                  return;
                }

                setState(() => loading = true);

                final error =
                    await transactionService.registrarPago(
                  userId: SessionService.userId!,
                  monto: double.parse(montoController.text),
                  descripcion: "Pago de $selectedService",
                );

                setState(() => loading = false);

                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pago realizado correctamente"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },

        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Pagar ahora",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}