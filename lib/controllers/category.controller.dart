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
  TextEditingController dateCtrl = TextEditingController(text: '');

  final _categories = <dynamic>[].obs;
  var type = ''.obs;
  var category = ''.obs;
  var amount = ''.obs;
  var previousAmount = ''.obs;
  var observation = ''.obs;
  var date = Rxn<DateTime>();
  var isSaving = false.obs;

  void resetForm() {
    formKey.currentState?.reset();
    type.value = '';
    category.value = '';
    amount.value = '';
    observation.value = '';
    _categories.value = [];
  }

  List<dynamic> get categories {
    // ignore: invalid_use_of_protected_member
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
    final d = (date.value == null) ? DateTime.now() : date.value;
    final data = Expense(
        cost: double.parse(amount.value),
        date: d!.toIso8601String(),
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

    try {
      final saved = await ExpenseController.to.saveExpense(data);
      isSaving.value = false;
      if (!saved) return;
      await updateTotals(data);
    } catch (e) {
      Get.defaultDialog(title: 'Error', content: Text(e.toString()));
      isSaving.value = false;
    }
  }

  Future<void> updateTransaction(String id) async {
    isSaving.value = true;
    final d = (date.value == null) ? DateTime.now() : date.value;
    final data = Expense(
        cost: double.parse(amount.value),
        date: d!.toIso8601String(),
        description: category.value,
        id: id,
        observation: observation.value.isEmpty ? null : observation.value,
        quantity: 1);

    final saved = await ExpenseController.to.updateExpense(data);
    if (!saved) return;
    data.cost = double.parse(amount.value) - double.parse(previousAmount.value);
    await updateTotals(data);
  }

  Future<void> updateTotals(Expense data) async {
    await BalanceController.to.updateBalance(data, type.value);
    isSaving.value = false;
    Get.back();
    Get.snackbar('Saved', 'Save correctly');
  }
}
