import 'package:flutter/material.dart';

class QRScreen extends StatelessWidget {

  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("QR"),
      ),

      body: const Center(
        child: Text(
          "Pantalla QR",
        ),
      ),
    );
  }
}