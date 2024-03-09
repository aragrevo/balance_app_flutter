import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);
  static const String routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Transaction'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: const Column(
            children: [
              Hero(
                  tag: 'bitcoin-image',
                  child: Image(
                      image: AssetImage('assets/images/bitcoin_transfer.png'))),
              TransactionForm(),
            ],
          ),
        ),
      ),
    );
  }
}
