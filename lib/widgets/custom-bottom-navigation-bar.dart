// ignore: file_names
import 'package:balance_app/controllers/home.controller.dart';
import 'package:balance_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 65,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(HomeController.to.currentIndex.value == 0
                      ? Icons.home_rounded
                      : Icons.home_outlined),
                  onPressed: () {
                    HomeController.to.changePage(0);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(HomeController.to.currentIndex.value == 1
                      ? Icons.account_balance_wallet_rounded
                      : Icons.account_balance_wallet_outlined),
                  onPressed: () {
                    HomeController.to.changePage(1);
                  },
                ),
              ),
              const Expanded(child: Text('')),
              Expanded(
                child: IconButton(
                  icon: Icon(HomeController.to.currentIndex.value == 2
                      ? Icons.pie_chart
                      : Icons.pie_chart_outline),
                  onPressed: () {
                    HomeController.to.changePage(2);
                  },
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
      ),
    );
  }
}
