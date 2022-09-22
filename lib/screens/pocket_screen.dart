import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/pocket.service.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/utils/theme_colors.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PocketScreen extends StatelessWidget {
  PocketScreen({Key? key}) : super(key: key);

  final pocketCtrl = Get.put(PocketController());

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.savings_rounded),
                  title: Text('Total I have',
                      style: TextStyle(
                        color: ThemeColors.to.black,
                      )),
                  trailing: Text(
                    toCurrency(PocketController.to.totalPockets),
                    style: TextStyle(
                        color: ThemeColors.to.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _WalletsSection(),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            return _ListSection(
                              title: 'Rest of balance',
                              amount: toCurrency(
                                  PocketController.to.totalPocketRest),
                              pockets: PocketController.to.pocketRest,
                            );
                          }),
                          Obx(() {
                            return _ListSection(
                              title: 'Saved pockets',
                              amount: toCurrency(
                                  PocketController.to.totalPocketSaved),
                              pockets: PocketController.to.pocketSaved,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.18,
                    minChildSize: 0.18,
                    maxChildSize: 0.99,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      final list =
                          PocketController.to.balanceInWallets.entries.toList();
                      list.sort(((a, b) => b.value.compareTo(a.value)));
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.indigoAccent.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    final item = list[index];
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(pocketIcons[
                                            item.key.toLowerCase()]),
                                        title: Text(item.key.toCapitalize,
                                            style: TextStyle(
                                              color: ThemeColors.to.black,
                                            )),
                                        trailing: Text(
                                          toCurrency(item.value),
                                          style: TextStyle(
                                              color: ThemeColors.to.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({
    Key? key,
    required this.title,
    required this.amount,
    required this.pockets,
  }) : super(key: key);

  final String title;
  final String amount;
  final List<Pocket> pockets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                amount,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 2.9,
          child: _PocketList(pockets: pockets),
        ),
      ],
    );
  }
}

class _PocketList extends StatelessWidget {
  const _PocketList({
    Key? key,
    required this.pockets,
  }) : super(key: key);

  final List<Pocket> pockets;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: pockets.length,
        itemBuilder: (context, index) {
          final pocket = pockets[index];
          return GestureDetector(
            onTap: () {
              PocketController.to.pocketToDelete.value = null;
              PocketController.to.resetForm();
              Get.bottomSheet(PocketForm(pocket: pocket),
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))));
            },
            onLongPress: () {
              PocketController.to.pocketToDelete.value =
                  (PocketController.to.pocketToDelete.value?.id == pocket.id)
                      ? null
                      : PocketController.to.pocketToDelete.value = pocket;
            },
            child: Obx(() {
              return Stack(
                children: [
                  Positioned(
                    child: _CustomCard(
                        title: pocket.name,
                        subtitle: toCurrency(pocket.value),
                        isNegative: pocket.value < 0,
                        observation: pocket.location,
                        icon: pocketIcons[pocket.location.toLowerCase()] ??
                            Icons.alarm),
                  ),
                  if (PocketController.to.pocketToDelete.value?.id == pocket.id)
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                          iconSize: 30,
                          color: Colors.red,
                          onPressed: () async {
                            await PocketService()
                                .deletePocket(pocket.id!, pocket);
                          },
                          icon: const Icon(Icons.cancel_rounded)),
                    ),
                ],
              );
            }),
          );
        });
  }
}

class _WalletsSection extends StatelessWidget {
  const _WalletsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepOrange[200]!.withOpacity(0.6),
      child: Container(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final balance = BalanceController.to.balance?.balance;
            final total = BalanceController.to.wallet
                .fold<int>(0, (prev, element) => prev + element.value);
            final int overage = total - (balance?.value ?? 0);
            final int diff = overage - PocketController.to.totalPocketRest;
            final bool isNegative = diff < 0;
            return Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WalletState(
                      wallet: Wallet(
                          value: balance?.value ?? 0, name: 'Should be')),
                  _WalletState(wallet: Wallet(name: 'Have', value: total)),
                  _WalletState(wallet: Wallet(name: 'Overage', value: overage)),
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
                                      toCurrency(diff),
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
                                    borderRadius: BorderRadius.circular(12.0)),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                          ),
                        )
                      else
                        ...BalanceController.to.wallet
                            .map((e) => _WalletWidget(wallet: e))
                            .toList()
                    ],
                  ))
            ]);
          })),
    );
  }
}

class _WalletWidget extends StatelessWidget {
  const _WalletWidget({
    Key? key,
    required this.wallet,
  }) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BalanceController.to.resetForm();
        Get.defaultDialog(
            title: wallet.name,
            middleText: toCurrency(wallet.value),
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
      child: _CustomCard(
        icon: walletIcons[wallet.icon]!,
        subtitle: toCurrency(wallet.value),
        title: wallet.name,
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard(
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
