import 'package:flutter/material.dart';

class RechargesScreen extends StatelessWidget {

  const RechargesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Recargas"),
      ),

      body: const Center(
        child: Text(
          "Pantalla de Recargas",
        ),
      ),
    );
  }
}