import 'package:flutter/material.dart';

import 'view/auth/login_screen.dart';
import 'view/home/timeline_solicitud_screen.dart';
import 'view/home/notificaciones_screen.dart';
import 'view/home/cronograma_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const LoginScreen(),

      routes: {
        "/timelineSolicitudes": (context) =>
            const TimelineSolicitudesScreen(),

        // 👇 AQUÍ agregas la nueva ruta
        '/notificaciones': (context) =>
            const NotificacionesScreen(),

        "/cronograma": (_) => const CronogramaScreen(),
      },
    );
  }
}