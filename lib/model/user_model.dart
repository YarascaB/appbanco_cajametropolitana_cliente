class UserModel {

  final String uid;
  final String nombre;
  final String dni;
  final String email;
  final double saldo;
  final double deuda;

  UserModel({

    required this.uid,
    required this.nombre,
    required this.dni,
    required this.email,
    required this.saldo,
    required this.deuda,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {

    return UserModel(

      uid: map['uid'],
      nombre: map['nombre'],
      dni: map['dni'],
      email: map['email'],
      saldo: (map['saldo'] ?? 0).toDouble(),
      deuda: (map['deuda'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {

    return {

      'uid': uid,
      'nombre': nombre,
      'dni': dni,
      'email': email,
      'saldo': saldo,
      'deuda': deuda,
    };
  }
}