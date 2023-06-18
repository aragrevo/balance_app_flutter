import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../utils/format.dart';

class BalanceChart extends StatelessWidget {
  const BalanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Obx(() {
        if (BalanceController.to.balance == null) {
          return const Center(
            child: Image(image: AssetImage('assets/images/empty.jpg')),
          );
        }
        return PieChart(
          PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 55,
              sections: showingSections()),
          swapAnimationDuration: const Duration(milliseconds: 550),
          swapAnimationCurve: Curves.linear,
        );
      }),
    );
  }

  List<PieChartSectionData> showingSections() {
    final authSvc = Provider.of<AuthService>(Get.context!, listen: false);
    const textStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    final revenue = BalanceController.to.balance?.revenue;
    final income = authSvc.isEuro ? revenue?.euro ?? 1 : revenue?.value ?? 1;
    return List.generate(
      2,
      (i) {
        switch (i) {
          case 0:
            final balance = BalanceController.to.balance?.balance;
            final value =
                authSvc.isEuro ? balance?.euro ?? 0 : balance?.value ?? 0;
            final p = ((value / income) * 100);
            final percentage = p.isNaN ? 0 : p.round();
            return PieChartSectionData(
              color: Colors.indigoAccent,
              value: percentage.toDouble(),
              title:
                  'Balance\n${authSvc.isEuro ? toCurrency(value, money: authSvc.money) : toSmallCurrency(value)}',
              radius: Get.width / 4.75,
              titleStyle: textStyle,
              badgeWidget: CircleAvatar(child: Text('$percentage%')),
              badgePositionPercentageOffset: .98,
              titlePositionPercentageOffset: 0.4,
            );
          case 1:
            final expense = BalanceController.to.balance?.expense;
            final value =
                authSvc.isEuro ? expense?.euro ?? 0 : expense?.value ?? 0;
            final p = ((value / income) * 100);
            final percentage = p.isNaN ? 0 : p.round();
            return PieChartSectionData(
                color: Colors.yellow[600],
                value: percentage.toDouble(),
                title:
                    'Expense\n${authSvc.isEuro ? toCurrency(value, money: authSvc.money) : toSmallCurrency(value)}',
                radius: Get.width / 5,
                badgeWidget: CircleAvatar(
                  child: Text('$percentage%'),
                ),
                badgePositionPercentageOffset: 1,
                titlePositionPercentageOffset: 0.4,
                titleStyle: textStyle);
          default:
            throw Error();
        }
      },
    );
  }
}
