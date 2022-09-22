import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/expense.controller.dart';
import 'package:balance_app/utils/format.dart';
import 'package:balance_app/widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      child: Column(
        children: [
          const CustomSpacer(20),
          const Expanded(child: _BalanceChart()),
          const CustomSpacer(20),
          Expanded(
            flex: 2,
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: const Color(0xff2c4260),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                    child: Column(
                      children: [
                        const _BalanceHeaderChart(),
                        const SizedBox(
                          height: 5,
                        ),
                        LegendsListWidget(
                          legends: [
                            Legend(
                                now
                                    .subtract(const Duration(days: 60))
                                    .nameMonth,
                                const Color(0xff632af2)),
                            Legend(
                                now
                                    .subtract(const Duration(days: 30))
                                    .nameMonth,
                                const Color(0xff53fdd7)),
                            Legend(now.nameMonth, const Color(0xffff5182)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => ExpenseController
                                .to.lastExpensesHistory.entries.isEmpty
                            ? const SizedBox()
                            : _ExpensesChart()),
                        const CustomSpacer(50)
                      ],
                    ))),
          ),
          // const CustomSpacer(50)
        ],
      ),
    );
  }
}

class Legend {
  final String name;
  final Color color;

  Legend(this.name, this.color);
}

class LegendsListWidget extends StatelessWidget {
  final List<Legend> legends;

  const LegendsListWidget({
    Key? key,
    required this.legends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class LegendWidget extends StatelessWidget {
  final String name;
  final Color color;

  const LegendWidget({
    Key? key,
    required this.name,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ExpensesChart extends StatelessWidget {
  _ExpensesChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(
      () => BarChart(BarChartData(
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                // interval: 1,
                getTitlesWidget: leftTitles,
              ),
            ),
          ),
          barGroups: showingGroups())),
    ));
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final exp = ExpenseController.to.lastExpensesHistory.entries.toList();
    final title = exp[value.toInt()].key;
    Widget text = Text(
      title,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
      angle: -1.2,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(meta.formattedValue, style: style),
    );
  }

  final colors = [
    const Color(0xff632af2),
    const Color(0xff53fdd7),
    const Color(0xffff5182),
    const Color(0xffffb3ba)
  ];

  List<BarChartGroupData> showingGroups() {
    return ExpenseController.to.lastExpensesHistory.entries.mapIndexed((i, e) {
      return BarChartGroupData(
          barsSpace: 1,
          x: i,
          barRods: e.value.reversed.mapIndexed((index, element) {
            return BarChartRodData(
              toY: element.toDouble(),
              color: colors[index],
              width: 7,
            );
          }).toList());
    }).toList();
  }
}

class _BalanceHeaderChart extends StatelessWidget {
  const _BalanceHeaderChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        makeTransactionsIcon(),
        const SizedBox(
          width: 38,
        ),
        const Text(
          'Transactions',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(
          width: 4,
        ),
        const Text(
          'expenses',
          style: TextStyle(color: Color(0xff77839a), fontSize: 16),
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}

class _BalanceChart extends StatelessWidget {
  const _BalanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Obx(
        () => PieChart(
          PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 55,
              startDegreeOffset: -90,
              sections: showingSections()),
          swapAnimationDuration: const Duration(milliseconds: 550),
          swapAnimationCurve: Curves.linear,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    const textStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    final income = BalanceController.to.balance?.revenue.value ?? 1;
    return List.generate(
      2,
      (i) {
        switch (i) {
          case 0:
            final value = BalanceController.to.balance?.balance.value ?? 0;
            final p = ((value / income) * 100);
            final percentage = p.isNaN ? 0 : p.round();
            return PieChartSectionData(
              color: Colors.indigoAccent,
              value: percentage.toDouble(),
              title: 'Balance\n${toSmallCurrency(value)}',
              radius: Get.width / 4.75,
              titleStyle: textStyle,
              badgeWidget: CircleAvatar(child: Text('$percentage%')),
              badgePositionPercentageOffset: .98,
              titlePositionPercentageOffset: 0.4,
            );
          case 1:
            final value = BalanceController.to.balance?.expense.value ?? 0;
            final p = ((value / income) * 100);
            final percentage = p.isNaN ? 0 : p.round();
            return PieChartSectionData(
                color: Colors.yellow[600],
                value: percentage.toDouble(),
                title: 'Expense\n${toSmallCurrency(value)}',
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
