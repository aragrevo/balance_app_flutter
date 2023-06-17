import 'dart:convert';

import 'package:balance_app/utils/format.dart';

Log logFromJson(String str) => Log.fromJson(json.decode(str));

String logToJson(Log data) => json.encode(data.toJson());

class Log {
  Log({
    required this.value,
    required this.name,
    required this.location,
    required this.date,
    required this.type,
    this.previousValue,
    this.description,
  });
  double value;
  double? previousValue;
  String name;
  String location;
  String date;
  String type;
  String? description;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        value: json["value"] != null
            ? double.parse(json["value"].toString())
            : double.parse(json["cost"].toString()),
        name: json['name'] != null
            ? json['name'].toString().toCapitalize
            : json['description'],
        type: json['type'] ?? '',
        location: json["location"] ?? json['description'] ?? '',
        date: json["date"] ?? '',
        previousValue: json["previousValue"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "name": name,
        "type": type,
        "location": location,
        "date": date,
        "previousValue": previousValue,
      };
}
