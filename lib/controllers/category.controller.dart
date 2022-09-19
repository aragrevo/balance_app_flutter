import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/controllers/expense.controller.dart';
import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/revenues.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:balance_app/services/categories.service.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _categories = <dynamic>[].obs;
  var type = ''.obs;
  var category = ''.obs;
  var amount = ''.obs;
  var observation = ''.obs;
  var isSaving = false.obs;

  List<dynamic> get categories {
    final cat = _categories.value;
    cat.sort(((a, b) => a['name'].compareTo(b['name'])));
    return cat;
  }

  Future<void> getCategories(String type) async {
    try {
      _categories.value = await CategoriesService().getCategories(type);
    } catch (e) {
      Get.defaultDialog(title: 'Error', content: Text(e.toString()));
      _categories.value = [];
    }
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> saveTransaction() async {
    isSaving.value = true;
    final data = Expense(
        cost: int.parse(amount.value),
        date: DateTime.now().toIso8601String(),
        description: category.value,
        observation: observation.value.isEmpty ? null : observation.value,
        quantity: 1);

    if (type.value == 'revenue') {
      try {
        await RevenuesService().addRevenue(data);
        await updateTotals(data);
      } catch (e) {
        Get.defaultDialog(title: 'Error', content: Text(e.toString()));
        isSaving.value = false;
      }
      return;
    }

    final saved = await ExpenseController.to.saveExpense(data);
    if (!saved) return;
    await updateTotals(data);
  }

  Future<void> updateTotals(Expense data) async {
    await BalanceController.to.updateBalance(data, type.value);
    isSaving.value = false;
    Get.back();
    Get.snackbar('Saved', 'Save correctly');
  }
}
