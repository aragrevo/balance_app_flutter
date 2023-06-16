import 'dart:convert';

BalanceDetail balanceDetailFromJson(String str) =>
    BalanceDetail.fromJson(json.decode(str));

String balanceDetailToJson(BalanceDetail data) => json.encode(data.toJson());

class BalanceDetail {
  BalanceDetail(
      {required this.value,
      required this.name,
      this.icon,
      this.position,
      this.euro,
      required this.observation,
      required this.id});
  int value;
  String name;
  String? icon;
  int? position;
  String id;
  String observation;
  int? euro;

  factory BalanceDetail.fromJson(Map<String, dynamic> json) => BalanceDetail(
      value: json["value"],
      name: json['name'],
      icon: json["icon"],
      id: json["id"],
      observation: json["observation"],
      position: json["position"],
      euro: json["euro"]);

  Map<String, dynamic> toJson() => {
        "value": value,
        "name": name,
        "icon": icon,
        "observation": observation,
        "id": id,
        "euro": euro
      };
}

enum Money { cop, eur }
