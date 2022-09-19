import 'dart:convert';

import 'package:balance_app/utils/format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  Expense({
    required this.cost,
    required this.date,
    required this.description,
    required this.quantity,
    this.observation,
    this.id,
  });
  int cost;
  String date;
  String description;
  int quantity;
  String? observation;
  String? id;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        cost: json["cost"],
        date: json["date"],
        description: json['description'].toString().split("_")[0].toCapitalize,
        quantity: json["quantity"],
        observation: json["observation"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "date": date,
        "description": description,
        "quantity": quantity,
        "observation": observation,
      };

  // factory Expense.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) =>
  //     Expense(
  //       cost: documentSnapshot.data()!['cost'],
  //       date: documentSnapshot.data()["date"],
  //       description: documentSnapshot.data()["description"],
  //       quantity: documentSnapshot.data()["quantity"],
  //       observation: documentSnapshot.data()["observation"],
  //     );
}
