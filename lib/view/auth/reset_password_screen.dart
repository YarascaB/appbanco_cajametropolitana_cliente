import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final emailController = TextEditingController();

  final authService = AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Recuperar contraseña",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Correo",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(

              onPressed: () async {

                final error =
                    await authService.resetPassword(
                  emailController.text,
                );

                if (error == null) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Correo enviado",
                      ),
                    ),
                  );

                } else {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    SnackBar(
                      content: Text(error),
                    ),
                  );
                }
              },

              child: const Text(
                "Enviar correo",
              ),
            ),
          ],
        ),
      ),
    );
  }
}