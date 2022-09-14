import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
          // elevation: 0,
          // color: const Color.fromRGBO(249, 249, 249, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Obx(
                () => PieChart(PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    sections: showingSections())),
              ),
            ),
          )),
    );
  }

  List<PieChartSectionData> showingSections() {
    const textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff));
    return List.generate(
      2,
      (i) {
        switch (i) {
          case 0:
            final value = BalanceController.to.balance['balance']?['value'];
            final percentage =
                ((value / BalanceController.to.balance['revenue']?['value']) *
                        100)
                    .round();
            return PieChartSectionData(
              color: Colors.indigoAccent,
              value: percentage.toDouble(),
              title: 'Balance\n${toCurrency(value)}',
              radius: Get.width / 3,
              titleStyle: textStyle,
              badgeWidget: CircleAvatar(child: Text('$percentage%')),
              badgePositionPercentageOffset: .98,
            );
          case 1:
            final value = BalanceController.to.balance['expense']?['value'];
            final percentage =
                ((value / BalanceController.to.balance['revenue']?['value']) *
                        100)
                    .round();
            return PieChartSectionData(
                color: Colors.yellow[600],
                value: percentage.toDouble(),
                title: 'Expense\n${toCurrency(value)}',
                radius: Get.width / 3,
                badgeWidget: CircleAvatar(child: Text('$percentage%')),
                badgePositionPercentageOffset: .98,
                titleStyle: textStyle);
          default:
            throw Error();
        }
      },
    );
  }
}
