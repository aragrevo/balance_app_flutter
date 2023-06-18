import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:balance_app/models/balance.dart';
import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/models/expense.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class BalanceController extends GetxController {
  static BalanceController get to => Get.find();
  final authSvc = Provider.of<AuthService>(Get.context!, listen: false);
  final Rxn<Balance> _balance = Rxn<Balance>();
  final RxList<Wallet> _wallet = RxList<Wallet>();

  final RxString newValue = ''.obs;
  final RxString updateValue = ''.obs;
  final isUpdating = false.obs;

  Balance? get balance => _balance.value;
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
    wallet.value = double.parse(value);
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
            (wallet.value + double.parse(newValue.value)).toString();
        break;
      case Operation.rest:
        updateValue.value =
            (wallet.value - double.parse(newValue.value)).toString();
        break;
    }

    isUpdating.value = true;
    newValue.value = '';
  }

  void resetForm() {
    newValue.value = '';
    updateValue.value = '';
    isUpdating.value = false;
  }

  Future<void> updateBalance(Expense data, String type) async {
    final obj = balance;
    if (obj == null) return;
    final currentMonth = BalanceService().getCurrentMonth();
    final category = type == 'revenue' ? obj.revenue : obj.expense;
    category.observation = data.date;
    if (authSvc.money == Money.eur) {
      category.euro = (category.euro ?? 0) + data.cost;
      obj.balance.euro = (obj.revenue.euro ?? 0) - (obj.expense.euro ?? 0);
    } else {
      category.value += data.cost;
      obj.balance.value = obj.revenue.value - obj.expense.value;
    }
    obj.balance.observation = data.date;
    await BalanceService().saveTotals(currentMonth, obj);
  }

  createBalance() {
    Get.defaultDialog(
        title: 'Are you sure?',
        middleText: 'Create a new Balance for this month',
        actions: [
          ElevatedButton(
              onPressed: () async {
                final currentMonth = BalanceService().getCurrentMonth();
                final detailBalance = _createDetail('balance');
                final detailExpense = _createDetail('expense');
                final detailRevenue = _createDetail('revenue');
                final balance = Balance(
                    id: currentMonth,
                    balance: detailBalance,
                    expense: detailExpense,
                    revenue: detailRevenue);
                await BalanceService().addTotals(balance);
                Get.back();
              },
              child: const Text('Yes, I am'))
        ]);
  }

  BalanceDetail _createDetail(String type) {
    return BalanceDetail(
        value: 0,
        name: type,
        observation: DateTime.now().toIso8601String(),
        id: type);
  }
}
