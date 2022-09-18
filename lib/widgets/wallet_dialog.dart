import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletDialog extends StatelessWidget {
  const WalletDialog({Key? key, required this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Previous value'),
              Text(toCurrency(wallet.value)),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(() => TextFormField(
                initialValue: BalanceController.to.newValue.value,
                onChanged: (value) =>
                    BalanceController.to.newValue.value = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'New value',
                  suffixIcon: Icon(walletIcons[wallet.icon]),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor ingrese un monto';
                  }
                },
              )),
        ],
      ),
    );
  }
}
