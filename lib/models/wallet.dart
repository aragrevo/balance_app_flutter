import 'dart:convert';

Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet(
      {required this.value, required this.name, this.icon, this.id, this.euro});
  int value;
  int? euro;
  String name;
  String? icon;
  String? id;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        value: json["value"],
        euro: json["euro"],
        name: json['name'],
        icon: json["icon"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "euro": euro,
        "name": name,
        "icon": icon,
        "id": id,
      };
}
