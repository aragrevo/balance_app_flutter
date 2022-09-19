import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/widgets/widgets.dart';
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
          const CustomSpacer(10),
          Obx(() => BalanceController.to.isUpdating.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Update value'),
                    Text(toCurrency(BalanceController.to.updateValue.value)),
                  ],
                )
              : const SizedBox()),
          const CustomSpacer(10),
          const Divider(),
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
          const CustomSpacer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OperationButton(
                onPressed: () => BalanceController.to
                    .updatePocketValue(wallet, Operation.sum),
                operation: Operation.sum,
              ),
              const SizedBox(
                width: 20,
              ),
              OperationButton(
                onPressed: () => BalanceController.to
                    .updatePocketValue(wallet, Operation.rest),
                operation: Operation.rest,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
