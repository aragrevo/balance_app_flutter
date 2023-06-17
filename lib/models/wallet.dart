import 'dart:convert';

Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet(
      {required this.value, required this.name, this.icon, this.id, this.euro});
  double value;
  double? euro;
  String name;
  String? icon;
  String? id;

  factory Wallet.fromJson(Map<String, dynamic> json) {
    final euro = '${json['euro'] ?? 0}';
    final pesos = '${json['value'] ?? 0}';
    try {
      final wallet = Wallet(
        value: double.parse(pesos),
        euro: double.parse(euro),
        name: json['name'],
        icon: json["icon"],
        id: json["id"],
      );
      return wallet;
    } catch (e) {
      print('error $e');
      return Wallet(value: 0, name: '');
    }
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "euro": euro,
        "name": name,
        "icon": icon,
        "id": id,
      };
}
