import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/screens/pocket/components/have.dart';
import 'package:balance_app/services/pocket.service.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/utils/icons.dart';
import 'package:balance_app/utils/theme_colors.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import 'components/wallet_section.dart';

class PocketScreen extends StatelessWidget {
  PocketScreen({Key? key}) : super(key: key);

  final pocketCtrl = Get.put(PocketController());

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    final money = authSvc.money;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Have(),
          const WalletsSection(),
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
                                PocketController.to.totalPocketRest,
                                money: money),
                            pockets: PocketController.to.pocketRest,
                          );
                        }),
                        Obx(() {
                          return _ListSection(
                            title: 'Saved pockets',
                            amount: toCurrency(
                                PocketController.to.totalPocketSaved,
                                money: money),
                            pockets: PocketController.to.pocketSaved,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.25,
                  minChildSize: 0.25,
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
                                  final icon =
                                      pocketIcons[item.key.toLowerCase()] ??
                                          Icons.image_not_supported_outlined;
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(icon),
                                      title: Text(item.key.toCapitalize,
                                          style: TextStyle(
                                            color: ThemeColors.to.black,
                                          )),
                                      trailing: Text(
                                        toCurrency(item.value,
                                            money: authSvc.money),
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
          aspectRatio: 3,
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
    final authSvc = Provider.of<AuthService>(context, listen: false);
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
              Get.bottomSheet(
                  PocketForm(
                    pocket: pocket,
                    money: authSvc.money!,
                  ),
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
                    child: CustomCard(
                        title: pocket.name,
                        subtitle:
                            toCurrency(pocket.value, money: authSvc.money),
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
