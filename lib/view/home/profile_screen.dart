import 'package:flutter/material.dart';

import '../../services/client_detail_service.dart';
import '../../services/session_service.dart';
import '../../ui/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: AppColors.primary),
          ),
          SizedBox(height: 15),
          Text(
            "Mi Perfil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 📦 CONTENIDO
  Widget _content(String userId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ClientDetailService().obtenerCliente(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No se encontró información"));
        }

        final cliente = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _userCard(cliente),
              const SizedBox(height: 25),

              _sectionTitle("Información personal"),
              const SizedBox(height: 15),

              _infoCard("DNI", cliente["dni"] ?? ""),
              _infoCard("Género", cliente["genero"] ?? ""),
              _infoCard("Zona", cliente["zona_negocio"] ?? ""),

              const SizedBox(height: 20),
              _sectionTitle("Perfil financiero"),
              const SizedBox(height: 15),

              _scoreCard(cliente),
              _infoCard("Tipo de negocio", cliente["tipo_negocio"] ?? ""),
              _infoCard("Segmento", cliente["segmento"] ?? ""),
              _infoCard(
                "Monto máximo sugerido",
                "S/. ${cliente["monto_max_sugerido"]}",
              ),
            ],
          ),
        );
      },
    );
  }

  /// 👤 USER CARD
  Widget _userCard(Map<String, dynamic> cliente) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "${cliente["nombres"]} ${cliente["apellidos"]}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(SessionService.email ?? ""),
        ],
      ),
    );
  }

  /// 📊 SCORE CARD DESTACADO
  Widget _scoreCard(Map<String, dynamic> cliente) {
    final score = cliente["score"] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0066FF), AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Score crediticio",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            "$score",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🧾 INFO CARD MODERNO
  Widget _infoCard(String titulo, String valor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}