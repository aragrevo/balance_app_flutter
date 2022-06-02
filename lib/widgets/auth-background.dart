import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[300],
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          const _FirstBox(),
          SafeArea(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child:
                  const Icon(Icons.person_pin, size: 100, color: Colors.white),
            ),
          ),
          child,
        ]));
  }
}

class _FirstBox extends StatelessWidget {
  const _FirstBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1),
            Color.fromRGBO(90, 70, 178, 1)
          ],
        ),
      ),
      child: Stack(children: [
        Positioned(child: _Bubble(), top: 90, left: 30),
        Positioned(child: _Bubble(), top: -40, left: -30),
        Positioned(child: _Bubble(), top: -50, right: -20),
        Positioned(child: _Bubble(), bottom: -50, left: 10),
        Positioned(child: _Bubble(), bottom: 120, right: 20)
      ]),
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
