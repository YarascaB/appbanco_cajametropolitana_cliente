class TransactionModel {

  final String tipo;
  final String descripcion;
  final double monto;
  final String fecha;

  TransactionModel({

    required this.tipo,
    required this.descripcion,
    required this.monto,
    required this.fecha,
  });

  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TransactionModel(

      tipo: json["tipo"],

      descripcion: json["descripcion"],

      monto: double.parse(
        json["monto"].toString(),
      ),

      fecha: json["fecha"],
    );
  }
}