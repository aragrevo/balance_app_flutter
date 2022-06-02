import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  Expense(
      {required this.cost,
      required this.date,
      required this.description,
      required this.quantity,
      this.observation});
  int cost;
  String date;
  String description;
  int quantity;
  String? observation;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        cost: json["cost"],
        date: json["date"],
        description: json["description"],
        quantity: json["quantity"],
        observation: json["observation"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "date": date,
        "description": description,
        "quantity": quantity,
        "observation": observation,
      };
}
