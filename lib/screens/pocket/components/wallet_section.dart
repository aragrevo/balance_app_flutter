import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/services.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../controllers/balance.controller.dart';
import '../../../controllers/pocket.controller.dart';
import '../../../models/pocket.dart';
import '../../../utils/format.dart';
import '../../../utils/theme_colors.dart';
import '../../../widgets/widgets.dart';

class WalletsSection extends StatelessWidget {
  const WalletsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.deepOrange[200]!.withOpacity(0.6),
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              final isEuro = authSvc.money == Money.eur;
              final ctrlBalance = BalanceController.to.balance?.balance;

              final balance =
                  isEuro ? ctrlBalance?.euro ?? 0 : ctrlBalance?.value;
              final total = BalanceController.to.wallet.fold<double>(
                  0,
                  (prev, element) =>
                      prev + (isEuro ? element.euro ?? 0 : element.value));
              final double overage = total - (balance ?? 0);
              final double diff = overage - PocketController.to.totalPocketRest;
              final bool isNegative = diff < 0;
              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _WalletState(
                        wallet: Wallet(value: balance ?? 0, name: 'Should be')),
                    _WalletState(wallet: Wallet(name: 'Have', value: total)),
                    _WalletState(
                        wallet: Wallet(name: 'Overage', value: overage)),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Column(
                        children: [
                          Card(
                              color: (isNegative)
                                  ? Colors.redAccent.withOpacity(0.3)
                                  : ThemeColors.to.backgroundCard,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Column(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        toCurrency(diff, money: authSvc.money),
                                        style: TextStyle(
                                            color: ThemeColors.to.darkgray,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const CustomSpacer(5),
                          FloatingActionButton(
                              tooltip: 'Add pocket',
                              child: Icon(
                                Icons.add,
                                color: ThemeColors.to.darkgray,
                              ),
                              elevation: 2,
                              backgroundColor: Colors.white,
                              onPressed: () {
                                PocketController.to.resetForm();
                                Get.bottomSheet(
                                    PocketForm(
                                        pocket: Pocket(
                                            value: 0,
                                            name: '',
                                            location: '',
                                            restOfBalance: false)),
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16))));
                              }),
                        ],
                      ),
                    )
                  ],
                ),
                const CustomSpacer(16),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (BalanceController.to.wallet.isEmpty)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                PocketController.to.createWallets();
                              },
                              child: const Text('Add wallets'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow,
                                  onPrimary: Colors.black,
                                  shadowColor: Colors.yellowAccent,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ),
                          )
                        else
                          ...BalanceController.to.wallet
                              .map((e) => _WalletWidget(
                                    wallet: e,
                                    money: authSvc.money,
                                  ))
                              .toList()
                      ],
                    ))
              ]);
            })),
      ),
    );
  }
}

class _WalletState extends StatelessWidget {
  const _WalletState({
    Key? key,
    required this.wallet,
  }) : super(key: key);
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _VerticalText(
          text: wallet.name,
        ),
        const SizedBox(
          width: 7,
        ),
        Container(
          width: 30,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              border: Border.all(color: ThemeColors.to.darkgray)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeColors.to.darkgray,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: _VerticalText(
                    text: toSmallCurrency(wallet.value),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        // ),
      ],
    );
  }
}

class _VerticalText extends StatelessWidget {
  const _VerticalText({
    Key? key,
    required this.text,
    this.color = const Color(0xff77839a),
    this.size = 10,
  }) : super(key: key);
  final String text;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: 3,
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: size),
        ));
  }
}

class _WalletWidget extends StatelessWidget {
  const _WalletWidget({Key? key, required this.wallet, this.money})
      : super(key: key);

  final Wallet wallet;
  final Money? money;

  @override
  Widget build(BuildContext context) {
    final value = money == Money.eur ? wallet.euro : wallet.value;
    return GestureDetector(
      onTap: () {
        BalanceController.to.resetForm();
        Get.defaultDialog(
            title: wallet.name,
            middleText: toCurrency(wallet.value, money: money),
            content: WalletDialog(
              wallet: wallet,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  BalanceController.to.saveWallet(wallet);
                },
                child: const Text('Save'),
              )
            ]);
      },
      child: CustomCard(
        icon: walletIcons[wallet.icon]!,
        subtitle: toCurrency(value ?? 0, money: money),
        title: wallet.name,
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon,
      this.isNegative = false,
      this.observation})
      : super(key: key);

  final String title;
  final String subtitle;
  final String? observation;
  final IconData icon;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (isNegative)
          ? Colors.redAccent.withOpacity(0.3)
          : ThemeColors.to.backgroundCard,
      child: Container(
          width: 100,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 38,
                color: ThemeColors.to.darkgray,
              ),
              const SizedBox(height: 5),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  title.toCapitalize,
                  style: TextStyle(
                      color: ThemeColors.to.black, fontWeight: FontWeight.bold),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  subtitle,
                  style:
                      TextStyle(color: ThemeColors.to.darkgray, fontSize: 12),
                ),
              ),
              observation != null
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        observation!,
                        style: TextStyle(
                            color: ThemeColors.to.darkgray, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    );
  }
}
