import 'package:balance_app/controllers/category.controller.dart';
import 'package:balance_app/controllers/expense.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/balance.service.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);
  static const String routeName = '/transaction';
  final categoryCtrl = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: const _Form(),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceSvc = Provider.of<BalanceService>(context);

    return Form(
      key: CategoryController.to.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Type'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor seleccione un tipo';
                }
              },
              items: const [
                DropdownMenuItem(
                  child: Text('Expense'),
                  value: 'expense',
                ),
                DropdownMenuItem(
                  child: Text('Income'),
                  value: 'revenue',
                ),
              ],
              onChanged: (value) {
                CategoryController.to.type.value = value as String;
                CategoryController.to.category.value = '';
                CategoryController.to.getCategories(value);
              }),
          const SizedBox(height: 20),
          Obx(
            () => DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un tipo';
                  }
                },
                items: CategoryController.to.categories
                    .map((category) => DropdownMenuItem(
                          child: Text(category['name']),
                          value: category['id'],
                        ))
                    .toList(),
                onChanged: (value) {
                  CategoryController.to.category.value = value as String;
                }),
          ),
          const SizedBox(height: 20),
          Obx(
            () => TextFormField(
              initialValue: CategoryController.to.amount.value,
              onChanged: (value) => CategoryController.to.amount.value = value,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                suffixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingrese un monto';
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => ElevatedButton(
                  onPressed: ExpenseController.to.isSaving.value
                      ? null
                      : () async {
                          if (!CategoryController.to.isValidForm()) return;
                          final data = Expense(
                              cost:
                                  int.parse(CategoryController.to.amount.value),
                              date: DateTime.now().toIso8601String(),
                              description: CategoryController.to.category.value,
                              quantity: 1);
                          final saved =
                              await ExpenseController.to.saveExpense(data);
                          if (!saved) return;
                          final currentMonth = balanceSvc.getCurrentMonth();
                          await balanceSvc.getBalance(currentMonth);
                          final obj = balanceSvc.balance;
                          obj['expense']['value'] += data.cost;
                          obj['expense']['observation'] = data.date;
                          obj['balance']['value'] =
                              obj['revenue']['value'] - obj['expense']['value'];
                          obj['balance']['observation'] = data.date;
                          await balanceSvc.saveTotals(currentMonth, obj);

                          Get.back();
                          Get.snackbar('Saved', 'Save correctly');
                        },
                  child: ExpenseController.to.isSaving.value
                      ? const CircularProgressIndicator()
                      : const Text('Add transaction'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      onPrimary: Colors.black,
                      shadowColor: Colors.yellowAccent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                ),
              )),
        ],
      ),
    );
  }
}
