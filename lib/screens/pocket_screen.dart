import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PocketScreen extends StatelessWidget {
  PocketScreen({Key? key}) : super(key: key);

  final pocketCtrl = Get.put(PocketController());

  @override
  Widget build(BuildContext context) {
    return Container(
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
                title: const Text('Total I have',
                    style: TextStyle(
                      color: Color(0xff2B322F),
                    )),
                trailing: Text(
                  toCurrency(PocketController.to.totalPockets),
                  style: const TextStyle(
                      color: Color(0xff2B322F),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        return _ListSection(
                          title: 'Rest of balance',
                          amount:
                              toCurrency(PocketController.to.totalPocketRest),
                          pockets: PocketController.to.pocketRest,
                        );
                      }),
                      Obx(() {
                        return _ListSection(
                          title: 'Saved pockets',
                          amount:
                              toCurrency(PocketController.to.totalPocketSaved),
                          pockets: PocketController.to.pocketSaved,
                        );
                      }),
                    ],
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
                                color: Colors.indigoAccent.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
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
                                      leading: Icon(
                                          pocketIcons[item.key.toLowerCase()]),
                                      title: Text(item.key.toCapitalize,
                                          style: const TextStyle(
                                            color: Color(0xff2B322F),
                                          )),
                                      trailing: Text(
                                        toCurrency(item.value),
                                        style: const TextStyle(
                                            color: Color(0xff2B322F),
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
          return _CustomCard(
              title: pocket.name,
              subtitle: toCurrency(pocket.value),
              observation: pocket.location,
              icon: pocketIcons[pocket.location.toLowerCase()] ?? Icons.alarm);
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
            final balance = BalanceController.to.balance['balance'];
            final total = BalanceController.to.wallet
                .fold<int>(0, (prev, element) => prev + element.value);
            final int overage = total - (balance?['value'] ?? 0) as int;
            return Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WalletState(
                      wallet: Wallet(
                          value: balance?['value'] ?? 0, name: 'Should be')),
                  _WalletState(wallet: Wallet(name: 'Have', value: total)),
                  _WalletState(wallet: Wallet(name: 'Overage', value: overage)),
                  const SizedBox(
                    width: 100,
                    height: 100,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: BalanceController.to.wallet
                    .map((e) => _WalletWidget(wallet: e))
                    .toList(),
              )
            ]);
          })),
    );
  }
}

class _CustomRow extends StatelessWidget {
  const _CustomRow({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      // padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toCapitalize,
              style: const TextStyle(
                  color: Color(0xff2B322F),
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          Text(amount,
              style: const TextStyle(color: Color(0xff77839a), fontSize: 11)),
        ],
      ),
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
        print(wallet.name);
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
      this.observation})
      : super(key: key);

  final String title;
  final String subtitle;
  final String? observation;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          width: 100,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 38,
                color: const Color(0xff77839a),
              ),
              const SizedBox(height: 5),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xff2B322F), fontWeight: FontWeight.bold),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  subtitle,
                  style:
                      const TextStyle(color: Color(0xff77839a), fontSize: 12),
                ),
              ),
              observation != null
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        observation!,
                        style: const TextStyle(
                            color: Color(0xff77839a), fontSize: 12),
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
              border: Border.all(color: const Color(0xff77839a))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xff77839a),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
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
