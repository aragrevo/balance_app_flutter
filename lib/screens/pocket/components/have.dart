import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/format.dart';
import '../../../utils/theme_colors.dart';

class Have extends StatelessWidget {
  const Have({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.savings_rounded),
          title: Text('Total I have',
              style: TextStyle(
                color: ThemeColors.to.black,
              )),
          trailing: Text(
            toCurrency(PocketController.to.totalPockets, money: authSvc.money),
            style: TextStyle(
                color: ThemeColors.to.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
