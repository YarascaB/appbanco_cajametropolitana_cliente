class MovementModel {

  final String title;
  final double amount;
  final String type;
  final String date;

  MovementModel({

    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {

    return {

      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }

  factory MovementModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return MovementModel(

      title: map['title'],
      amount: map['amount'].toDouble(),
      type: map['type'],
      date: map['date'],
    );
  }
}