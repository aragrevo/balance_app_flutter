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
      notchMargin: 5.0,
      child: SizedBox(
        height: 50,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                  highlightColor: Colors.indigoAccent,
                  color: HomeController.to.currentIndex.value == 0
                      ? Colors.indigoAccent
                      : Colors.black12,
                  icon: const Icon(Icons.home_filled),
                  onPressed: () {
                    HomeController.to.changePage(0);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  highlightColor: Colors.indigoAccent,
                  color: HomeController.to.currentIndex.value == 1
                      ? Colors.indigoAccent
                      : Colors.black12,
                  icon: const Icon(Icons.account_balance_wallet_rounded),
                  onPressed: () {
                    HomeController.to.changePage(1);
                  },
                ),
              ),
              const Expanded(child: Text('')),
              Expanded(
                child: IconButton(
                  highlightColor: Colors.indigoAccent,
                  color: HomeController.to.currentIndex.value == 2
                      ? Colors.indigoAccent
                      : Colors.black12,
                  icon: const Icon(Icons.pie_chart),
                  onPressed: () {
                    HomeController.to.changePage(2);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  color: Colors.black12,
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    HomeController.to.openSettingsDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
