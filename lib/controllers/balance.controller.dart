import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/expense.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceController extends GetxController {
  static BalanceController get to => Get.find();
  final RxMap<String, dynamic> _balance = RxMap<String, dynamic>();
  final RxList<Wallet> _wallet = RxList<Wallet>();

  final RxString newValue = ''.obs;
  final RxString updateValue = ''.obs;
  final isUpdating = false.obs;

  Map<String, dynamic> get balance => _balance.value;
  List<Wallet> get wallet => _wallet.value;

  @override
  void onInit() {
    final monthName = BalanceService().getCurrentMonth();
    _balance.bindStream(BalanceService().balanceStream(monthName));
    _wallet.bindStream(BalanceService().walletStream());
  }

  Future<void> saveWallet(Wallet wallet) async {
    if (newValue.value.isEmpty && isUpdating.value == false) {
      Get.snackbar('Error', 'Value can not be empty',
          backgroundColor: Colors.yellowAccent.withOpacity(0.5));
      return;
    }
    final value =
        updateValue.value.isNotEmpty ? updateValue.value : newValue.value;
    wallet.value = int.parse(value);
    final saved = await BalanceService().saveBalance(wallet.id!, wallet);
    if (saved) {
      Get.back();
    }
  }

  void updatePocketValue(Wallet wallet, Operation operation) {
    if (newValue.value.isEmpty) {
      Get.snackbar('Error', 'Value can not be empty',
          backgroundColor: Colors.yellowAccent.withOpacity(0.5));
      return;
    }

    switch (operation) {
      case Operation.sum:
        updateValue.value =
            (wallet.value + int.parse(newValue.value)).toString();
        break;
      case Operation.rest:
        updateValue.value =
            (wallet.value - int.parse(newValue.value)).toString();
        break;
    }

    isUpdating.value = true;
    newValue.value = '';
  }

  void resetForm() {
    newValue.value = '';
    updateValue.value = '';
    isUpdating.value = false;
    // formKey.currentState?.reset();
  }

  Future<void> updateBalance(Expense data, String type) async {
    final obj = balance;
    final currentMonth = BalanceService().getCurrentMonth();
    final category = type == 'revenue' ? 'revenue' : 'expense';
    obj[category]['value'] += data.cost;
    obj[category]['observation'] = data.date;
    obj['balance']['value'] = obj['revenue']['value'] - obj['expense']['value'];
    obj['balance']['observation'] = data.date;
    await BalanceService().saveTotals(currentMonth, obj);
  }
}
