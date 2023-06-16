import 'dart:convert';

import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/utils/format.dart';

Pocket pocketFromJson(String str) => Pocket.fromJson(json.decode(str));

String pocketToJson(Pocket data) => json.encode(data.toJson());

class Pocket {
  Pocket(
      {required this.value,
      required this.name,
      required this.location,
      required this.restOfBalance,
      this.money,
      this.id});
  int value;
  String name;
  String location;
  bool restOfBalance;
  String? id;
  Money? money;

  factory Pocket.fromJson(Map<String, dynamic> json) => Pocket(
        value: int.parse(json["value"].toString()),
        name: json['name'].toString().toCapitalize,
        id: json["id"],
        money: json["money"],
        location: json["location"],
        restOfBalance: json["restOfBalance"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "name": name,
        "id": id,
        "money": money,
        "location": location,
        "restOfBalance": restOfBalance,
      };
}
