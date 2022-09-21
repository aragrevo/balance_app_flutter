import 'package:balance_app/controllers/home.controller.dart';
import 'package:balance_app/screens/logs_screen.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:balance_app/utils/theme_colors.dart';
import 'package:balance_app/widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                leading: const SizedBox(),
                backgroundColor: ThemeColors.to.darkblue,
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                elevation: 0,
                title: const Text('Settings')),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: 'Month to see'),
                Expanded(
                  child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: HomeController.to.months
                          .map(
                            (e) => ListTile(
                              title: Text(e),
                              tileColor: e ==
                                      HomeController.to.formattedDate(
                                          BalanceService().getCurrentMonth())
                                  ? Colors.grey[300]
                                  : null,
                              onTap: () {},
                            ),
                          )
                          .toList()),
                ),
                // const CustomSpacer(10),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 5,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(title: 'Other settings'),
                        ListTile(
                          title: const Text('New month'),
                          onTap: () {},
                          leading: const Icon(Icons.calendar_month_rounded),
                        ),
                        ListTile(
                          title: const Text('See logs'),
                          onTap: () {
                            Get.toNamed(LogsScreen.routeName);
                          },
                          leading: const Icon(Icons.list_rounded),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSpacer(10),
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.to.darkgray)),
          const Divider(),
        ],
      ),
    );
  }
}
