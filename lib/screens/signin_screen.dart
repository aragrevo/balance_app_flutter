import 'package:balance_app/main.dart';
import 'package:balance_app/services/services.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({Key? key}) : super(key: key);
  static const String routeName = 'signin';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authSvc = Provider.of<AuthService>(context);
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                height: size.height * 0.5,
                child: Stack(children: [
                  SafeArea(
                      child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Icon(Icons.person_pin,
                        size: 60, color: Colors.white),
                  )),
                  Positioned(child: _Bubble(), top: 90, left: 30),
                  Positioned(child: _Bubble(), top: -40, left: -30),
                  Positioned(child: _Bubble(), top: -50, right: -20),
                  Positioned(child: _Bubble(), bottom: 0, left: 10),
                  Positioned(child: _Bubble(), bottom: 120, right: 20),
                  Positioned(
                      child: Transform.rotate(
                          angle: 6 * math.pi / 180, child: _CreditCard()),
                      bottom: 0,
                      left: 100)
                ])),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Manage your finances the easy way',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 70),
                  SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                            onPrimary: Colors.black,
                            shadowColor: Colors.yellowAccent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        onPressed: authSvc.isLoading
                            ? null
                            : () async {
                                final account =
                                    await authSvc.signInWithGoogle();
                                if (account != null) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('home');
                                }
                              },
                        child: authSvc.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Sign up'),
                      )),
                ])),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}

class _Ring extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(180, 180, 180, 1),
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CreditCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 500,
          height: 90,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromRGBO(191, 191, 191, 1)),
        ),
        Container(
          width: 500,
          height: 190,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Color.fromRGBO(37, 37, 37, 1)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    _Ring(),
                    _Ring(),
                  ],
                ),
                const Text(
                  '1234  5678  9012  3456',
                  style: TextStyle(
                      fontSize: 28,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(180, 180, 180, 1)),
                ),
                const Text(
                  'Eduardo Vergara',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(180, 180, 180, 1)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
