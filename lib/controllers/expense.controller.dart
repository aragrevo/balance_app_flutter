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
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final lastMonths = [0, 1, 2];
    _expensesHistory.value.forEach((expense) {
      final expenseDate = DateTime.parse(expense.date);
      if (expenseDate.year == year) {
        for (var i = 0; i < lastMonths.length; i++) {
          if (expenseDate.month == month - i) {
            final hasData = list[expense.description];
            if (hasData == null || hasData.isEmpty) {
              list[expense.description] = List.filled(lastMonths.length, 0);
            }
            var oldValue = list[expense.description]![i];
            list[expense.description]![i] = oldValue + expense.cost;
          }
        }
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
      return true;
    } catch (e) {
      Get.defaultDialog(title: 'Error', content: Text(e.toString()));
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
