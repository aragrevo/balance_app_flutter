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
  double value;
  String name;
  String? icon;
  int? position;
  String id;
  String observation;
  double? euro;

  factory BalanceDetail.fromJson(Map<String, dynamic> json) {
    final euro = '${json['euro'] ?? 0}';
    final pesos = '${json['value'] ?? 0}';
    try {
      return BalanceDetail(
          value: double.parse(pesos),
          euro: double.parse(euro),
          name: json['name'],
          icon: json["icon"],
          id: json["id"],
          observation: json["observation"],
          position: json["position"]);
    } catch (e) {
      print('error $e');
      return BalanceDetail(id: '', name: '', observation: '', value: 0);
    }
  }

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
