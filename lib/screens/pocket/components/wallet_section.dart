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
              final bool isNegative = diff.floor() < 0;
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
                              elevation: 2,
                              backgroundColor: Colors.white,
                              onPressed: () {
                                PocketController.to.resetForm();
                                Get.bottomSheet(
                                    PocketForm(
                                        money: authSvc.money!,
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
                              },
                              child: Icon(
                                Icons.add,
                                color: ThemeColors.to.darkgray,
                              )),
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
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                  shadowColor: Colors.yellowAccent,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              child: const Text('Add wallets'),
                            ),
                          )
                        else
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 3.1,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 11),
                                itemCount: BalanceController.to.wallet.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final wallet =
                                      BalanceController.to.wallet[index];
                                  return _WalletWidget(
                                      wallet: wallet, money: authSvc.money);
                                },
                              ),
                            ),
                          )
                        // ...BalanceController.to.wallet
                        //     .map((e) => _WalletWidget(
                        //           wallet: e,
                        //           money: authSvc.money,
                        //         ))
                        //     .toList()
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
    final authSvc = Provider.of<AuthService>(context, listen: false);
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
                    text: authSvc.isEuro
                        ? toCurrency(wallet.value, money: authSvc.money)
                        : toSmallCurrency(wallet.value),
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
    final value = money == Money.eur ? wallet.euro ?? 0 : wallet.value;
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
      child: WalletCard(
        icon: walletIcons[wallet.icon]!,
        subtitle: value >= 1000000
            ? value.toString().toHuman
            : toCurrency(value, money: money),
        title: wallet.name,
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  const WalletCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.to.backgroundCard,
      clipBehavior: Clip.none,
      child: SizedBox(
          width: 85,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: ThemeColors.to.darkblue,
                      child: Icon(
                        icon,
                        size: 34,
                        color: ThemeColors.to.backgroundCard.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          title.toCapitalize,
                          style: TextStyle(
                              color: ThemeColors.to.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          subtitle,
                          style: TextStyle(
                              color: ThemeColors.to.darkgray, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
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
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(
                icon,
                size: 34,
                color: ThemeColors.to.darkgray,
              ),
              const SizedBox(height: 4),
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
