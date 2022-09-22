import 'dart:convert';

import 'package:balance_app/models/balance_detail.dart';

Balance balanceFromJson(String str) => Balance.fromJson(json.decode(str));

String balanceToJson(Balance data) => json.encode(data.toJson());

class Balance {
  Balance(
      {required this.balance,
      required this.expense,
      required this.revenue,
      this.id});
  BalanceDetail balance;
  BalanceDetail expense;
  BalanceDetail revenue;
  String? id;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        balance: BalanceDetail.fromJson(json["balance"]),
        expense: BalanceDetail.fromJson(json['expense']),
        revenue: BalanceDetail.fromJson(json["revenue"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance.toJson(),
        "expense": expense.toJson(),
        "revenue": revenue.toJson(),
      };
}
