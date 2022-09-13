import 'package:balance_app/services/balance.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/expenses.service.dart';

class ExpenseController extends GetxController {
  static ExpenseController get to => Get.find();
  final RxList<Expense> _expenses = RxList<Expense>();
  var isSaving = false.obs;

  List<Expense> get expensesList => _expenses.value;

  @override
  void onInit() {
    _expenses.bindStream(ExpensesService().expenseStream());
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
