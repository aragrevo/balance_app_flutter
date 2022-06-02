// ignore: file_names
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                onPressed: () {},
              ),
            ),
            const Expanded(child: Text('')),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.pie_chart_outline_rounded),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
