import 'dart:convert';

Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet({required this.value, required this.name, this.icon});
  int value;
  String name;
  String? icon;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        value: json["value"],
        name: json['name'],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "name": name,
        "icon": icon,
      };
}
