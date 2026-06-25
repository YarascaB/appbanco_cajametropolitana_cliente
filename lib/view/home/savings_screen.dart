import 'package:flutter/material.dart';

import '../../ui/theme/app_colors.dart';
import '../../services/savings_service.dart';
import '../../services/session_service.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SessionService.userId!;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          _header(),
          Expanded(child: _content(userId)),
        ],
      ),
    );
  }

  /// 🌟 HEADER PREMIUM
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: const Column(
        children: [
          Text(
            "Ahorros",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Controla tu crecimiento financiero",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// 📦 CONTENIDO
  Widget _content(String userId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: SavingsService().obtenerCuenta(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No existe información"));
        }

        final data = snapshot.data!;
        final cuenta = data["cuenta"] as Map<String, dynamic>;

        final saldo = double.tryParse(cuenta["saldo"].toString()) ?? 0;
        final meta = double.tryParse(cuenta["meta_ahorro"].toString()) ?? 1;
        final progress = (saldo / meta).clamp(0.0, 1.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _balanceCard(saldo, progress),
              const SizedBox(height: 25),
              _infoCard(cuenta),
              const SizedBox(height: 25),
              _sectionTitle("Últimos depósitos"),
              const SizedBox(height: 15),
              _timeline(),
            ],
          ),
        );
      },
    );
  }

  /// 💰 SALDO PRINCIPAL
  Widget _balanceCard(double saldo, double progress) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0066FF), AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Saldo de Ahorros",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 15),

          Text(
            "S/. ${saldo.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 6,
          ),

          const SizedBox(height: 10),

          Text(
            "${(progress * 100).toStringAsFixed(1)}% de tu meta",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// 📊 INFO FINANCIERA
  Widget _infoCard(Map<String, dynamic> cuenta) {
    return Container(
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
        children: [
          _row("Meta de ahorro", "S/. ${cuenta["meta_ahorro"]}"),
          _row("Tasa de interés", "${cuenta["tasa_interes"]}%"),
          _row("Fecha apertura", cuenta["fecha_apertura"]?.toString() ?? ""),
        ],
      ),
    );
  }

  Widget _row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(v, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  /// 🧾 TIMELINE DE DEPÓSITOS
  Widget _timeline() {
    final deposits = [
      ["Depósito en agente", "+ S/. 500"],
      ["Transferencia recibida", "+ S/. 300"],
    ];

    return Column(
      children: List.generate(deposits.length, (i) {
        final d = deposits[i];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (i * 120)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _depositTile(d[0], d[1]),
              ),
            );
          },
        );
      }),
    );
  }

  /// 💳 ITEM DEPÓSITO
  Widget _depositTile(String title, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_downward,
              color: AppColors.success,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "15 Mayo 2026",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}