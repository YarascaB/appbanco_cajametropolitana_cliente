import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/account_service.dart';
import '../../services/session_service.dart';
import '../../services/transaction_service.dart';

import '../../ui/theme/app_colors.dart';

import '../../widgets/movement_tile.dart';

import '../auth/login_screen.dart';

import 'credits_screen.dart';
import 'payments_screen.dart';
import 'profile_screen.dart';
import 'qr_screen.dart';
import 'recharges_screen.dart';
import 'savings_screen.dart';
import 'transfer_screen.dart';
import 'mis_solicitudes_screen.dart';
import 'buro_screen.dart';
import 'solicitud_credito_screen.dart';

import '../../model/transaction_model.dart';
import '../../viewmodel/home_viewmodel.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AccountService accountService = AccountService();
  final TransactionService transactionService = TransactionService();
  final HomeViewModel homeViewModel = HomeViewModel();

  late Future<double> saldoFuture;
  late Future<List<TransactionModel>> movimientosFuture;

  int currentIndex = 0;

  double _oldSaldo = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userId = SessionService.userId!;

    saldoFuture = accountService.obtenerSaldo(userId);
    movimientosFuture = transactionService.obtenerMovimientos(userId);

    homeViewModel.cargarUsuario(userId);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  void _logout() {
    SessionService.userId = null;
    SessionService.nombre = null;
    SessionService.email = null;
    SessionService.rol = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  /// 💰 animación dinero
  Widget _money(double value) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _oldSaldo, end: value),
      duration: const Duration(milliseconds: 700),
      onEnd: () => _oldSaldo = value,
      builder: (context, val, _) {
        return Text(
          "S/. ${val.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  /// 🧊 skeleton
  Widget _skeletonBox({double h = 20, double w = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// 🌫 blur loading
  Widget _blurLoading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 120,
          color: Colors.white.withOpacity(0.2),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = SessionService.nombre ?? "Cliente";

    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔥 bottom nav animado
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() => currentIndex = index);

            final screens = [
              null,
              const SavingsScreen(),
              const CreditosScreen(),
              const ProfileScreen(),
            ];

            if (screens[index] != null) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => screens[index]!,
                  transitionsBuilder: (_, anim, __, child) {
                    return FadeTransition(opacity: anim, child: child);
                  },
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            BottomNavigationBarItem(icon: Icon(Icons.savings), label: "Ahorros"),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Créditos"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _header(nombre),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _balanceCard(),
                    const SizedBox(height: 20),
                    _quickActions(),
                    const SizedBox(height: 20),
                    _movements(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String nombre) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF0057D9)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Caja Metropolitana",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notificaciones');
                    },
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            "Hola, $nombre",
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _balanceCard() {
    return FutureBuilder<double>(
      future: saldoFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _blurLoading();
        }

        final saldo = snap.data ?? 0;

        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0066FF), AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Saldo Disponible",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              _money(saldo),
            ],
          ),
        );
      },
    );
  }

  Widget _quickActions() {
    final items = [
      [Icons.send, "Transferir", const TransferScreen()],
      [Icons.receipt, "Pagar", const PaymentsScreen()],
      [Icons.phone_android, "Recargas", const RechargesScreen()],
      [Icons.qr_code, "QR", const QRScreen()],
      [Icons.assignment, "Mis Solicitudes", const MisSolicitudesScreen()],
      [Icons.assessment, "Buró", const BuroScreen()],
      [
      Icons.request_page,
      "Solicitar Crédito",
      const SolicitudCreditoScreen(),
    ],
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, i) {
        final item = items[i];

        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item[2] as Widget),
            );
            _refresh();
          },
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item[0] as IconData, color: AppColors.primary, size: 30),
                const SizedBox(height: 10),
                Text(item[1] as String),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _movements() {
    return FutureBuilder<List<TransactionModel>>(
      future: movimientosFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Column(
            children: List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _skeletonBox(h: 70),
              ),
            ),
          );
        }

        final data = snap.data ?? [];

        return Column(
          children: List.generate(data.length, (i) {
            final mov = data[i];

            return MovementTile(
              icon: mov.tipo == "debito"
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              title: mov.descripcion,
              date: mov.fecha,
              amount: "S/. ${mov.monto}",
              color: mov.tipo == "debito"
                  ? AppColors.danger
                  : AppColors.success,
            );
          }),
        );
      },
    );
  }
}