import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/screens/screens.dart';
import 'package:balance_app/services/auth_service.dart';
import 'package:balance_app/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    if (authSvc.user?.id == null) return const SizedBox();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ThemeColors.to.backgroundCard,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _Title(),
                      SizedBox(
                        height: 40,
                      ),
                      _MoneyList()
                    ],
                  ),
                ),
              ),
              const _Button()
            ],
          ),
        ),
      ),
    );
  }
}

class _MoneyList extends StatelessWidget {
  const _MoneyList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
      MoneyCard(
        money: Money.eur,
      ),
      MoneyCard(
        money: Money.cop,
      ),
    ]);
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ThemeColors.to.black),
      child: const Text(
        'Select your money',
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        child: const Text('Continue'),
        onPressed: () async {
          Get.offNamedUntil(HomeScreen.routeName, (route) => false);
        },
        style: ElevatedButton.styleFrom(
            primary: Colors.yellow,
            onPrimary: Colors.black,
            shadowColor: Colors.yellowAccent,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class MoneyCard extends StatelessWidget {
  const MoneyCard({
    Key? key,
    required this.money,
  }) : super(key: key);

  final Money money;

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context);
    final String text = money == Money.eur ? 'euro' : 'pesos';
    final isSelected = money == authSvc.money;
    return GestureDetector(
      onTap: isSelected
          ? null
          : () {
              authSvc.money = money;
            },
      child: Card(
        elevation: isSelected ? 1.0 : 5.0,
        color: isSelected ? ThemeColors.to.backgroundCard : Colors.white,
        child: Container(
            padding: const EdgeInsets.all(24),
            width: 150,
            height: 150,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -50,
                  left: 0,
                  child: Image(
                    image: AssetImage('assets/images/$text.png'),
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: ThemeColors.to.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                isSelected
                    ? const Positioned(
                        bottom: -24,
                        right: -24,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 32,
                        ),
                      )
                    : const SizedBox()
              ],
            )),
      ),
    );
  }
}
