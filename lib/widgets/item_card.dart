import 'package:balance_app/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int amount;
  final Widget? icon;
  const ItemCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.amount,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromRGBO(249, 249, 249, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: icon ??
            CircleAvatar(
                child: customIcons[title] ??
                    Text(title.substring(0, 2).toUpperCase())),
        title: Row(
          children: [
            Expanded(child: Text(title), flex: 1),
            Text(
                NumberFormat.currency(
                        locale: 'en_US', symbol: '💲', decimalDigits: 0)
                    .format(amount),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {}),
      ),
    );
  }
}
