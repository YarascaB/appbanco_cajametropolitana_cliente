class InstallmentModel {

  final String id;

  final String userId;

  final int numeroCuota;

  final String fechaVencimiento;

  final double monto;

  final String estado;

  InstallmentModel({

    required this.id,

    required this.userId,

    required this.numeroCuota,

    required this.fechaVencimiento,

    required this.monto,

    required this.estado,
  });

  factory InstallmentModel.fromJson(
      Map<String, dynamic> json) {

    return InstallmentModel(

      id: json["id"],

      userId: json["user_id"],

      numeroCuota:
          json["numero_cuota"],

      fechaVencimiento:
          json["fecha_vencimiento"],

      monto: double.parse(
        json["monto"].toString(),
      ),

      estado:
          json["estado"],
    );
  }
}