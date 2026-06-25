import 'package:flutter/material.dart';
import '../../ui/theme/app_colors.dart';
import '../../services/session_service.dart';
import '../../services/transfer_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final emailController = TextEditingController();
  final amountController = TextEditingController();

  final transferService = TransferService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          _header(),
          Expanded(child: _form()),
        ],
      ),
    );
  }

  /// 🌈 HEADER
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
          Icon(Icons.send, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text(
            "Transferencias",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Envía dinero de forma segura",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// 🧾 FORMULARIO
  Widget _form() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          _input(
            controller: emailController,
            icon: Icons.email,
            hint: "Correo del destinatario",
          ),

          const SizedBox(height: 20),

          _input(
            controller: amountController,
            icon: Icons.attach_money,
            hint: "Monto a transferir",
            isNumber: true,
          ),

          const SizedBox(height: 35),

          _button(),
        ],
      ),
    );
  }

  /// ✍️ INPUT MODERNO
  Widget _input({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  /// 🚀 BOTÓN
  Widget _button() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: loading ? null : _transferir,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Enviar dinero",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  /// 💸 LÓGICA
  Future<void> _transferir() async {
    setState(() => loading = true);

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Monto inválido")),
      );
      return;
    }

    final error = await transferService.transferir(
      senderUserId: SessionService.userId!,
      receiverEmail: emailController.text.trim(),
      monto: amount,
    );

    setState(() => loading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transferencia realizada")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}