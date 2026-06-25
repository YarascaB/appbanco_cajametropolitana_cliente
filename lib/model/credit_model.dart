class CreditModel {

  final String id;

  final double monto;

  final double saldo;

  final String estado;

  CreditModel({

    required this.id,

    required this.monto,

    required this.saldo,

    required this.estado,
  });

  factory CreditModel.fromJson(
      Map<String, dynamic> json) {

    return CreditModel(

      id: json["id"],

      monto:
          double.parse(
        json["monto"].toString(),
      ),

      saldo:
          double.parse(
        json["saldo"].toString(),
      ),

      estado:
          json["estado"],
    );
  }
}