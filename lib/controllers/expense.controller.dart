import 'package:balance_app/models/log.dart';
import 'package:balance_app/services/log.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/expenses.service.dart';

class ExpenseController extends GetxController {
  static ExpenseController get to => Get.find();
  final RxList<Expense> _expenses = RxList<Expense>();
  final RxList<Expense> _expensesHistory = RxList<Expense>();
  var isSaving = false.obs;

  List<Expense> get expensesList => _expenses.value;
  List<Expense> get expensesHistory => _expensesHistory.value;
  Map<String, List<int>> get lastExpensesHistory {
    final Map<String, List<int>> list = {};
    final date = DateTime.now();
    final currentFormatDate = '${date.year}${date.month}';
    final dateLastMonth = DateTime.now().subtract(const Duration(days: 30));
    final lastFormatDate = '${dateLastMonth.year}${dateLastMonth.month}';
    final dateSecondLastMonth =
        DateTime.now().subtract(const Duration(days: 60));
    final secondLastFormatDate =
        '${dateSecondLastMonth.year}${dateSecondLastMonth.month}';
    final objIndexes = {
      currentFormatDate: 0,
      lastFormatDate: 1,
      secondLastFormatDate: 2
    };
    _expensesHistory.value.forEach((expense) {
      final expenseDate = DateTime.parse(expense.date);
      final expenseFormatDate = '${expenseDate.year}${expenseDate.month}';
      final index = objIndexes[expenseFormatDate] ?? -1;
      if (index != -1) {
        final key = expense.description;
        final hasData = list[key];
        if (hasData == null || hasData.isEmpty) {
          list[key] = List.filled(3, 0);
        }
        var oldValue = list[key]![index];
        list[key]![index] = oldValue + expense.cost;
      }
    });
    return list;
  }

  @override
  void onInit() {
    _expenses.bindStream(ExpensesService().expenseStream());
    _expensesHistory.bindStream(ExpensesService().expenseHistoryStream());
  }

  Future<bool> saveExpense(Expense expense) async {
    isSaving.value = true;
    try {
      await ExpensesService().addExpense(expense);
      final log = Log(
        value: expense.cost,
        name: expense.description,
        location: expense.description,
        date: DateTime.now().toIso8601String(),
        type: 'expense',
      );
      LogService().saveLog(log);
      return true;
    } catch (e) {
      Get.defaultDialog(title: 'Error', content: Text(e.toString()));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    isSaving.value = true;
    try {
      await ExpensesService().updateExpense(expense);
      final log = Log(
        value: expense.cost,
        name: expense.description,
        location: expense.description,
        date: DateTime.now().toIso8601String(),
        type: 'expense',
      );
      LogService().saveLog(log);
      return true;
    } catch (e) {
      Get.defaultDialog(title: 'Error', content: Text(e.toString()));
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
