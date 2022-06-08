import 'package:balance_app/models/expense.dart';
import 'package:balance_app/providers/transaction_form.provider.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:balance_app/services/categories.service.dart';
import 'package:balance_app/services/expenses.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CategoriesService()),
      ChangeNotifierProvider(create: (_) => ExpensesService()),
      ChangeNotifierProvider(create: (_) => TransactionFormProvider()),
    ], child: const _Body());
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
        padding: EdgeInsets.all(20),
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
    final categoriesSvc = Provider.of<CategoriesService>(context);
    final expensesSvc = Provider.of<ExpensesService>(context);
    final balanceSvc = Provider.of<BalanceService>(context);
    final form = Provider.of<TransactionFormProvider>(context);
    final categories = categoriesSvc.categoriesList;
    final document = form.document;
    return Form(
      key: form.formKey,
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
                document['type'] = value;
                categoriesSvc.getCategories(value as String);
              }),
          const SizedBox(height: 20),
          DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Category'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor seleccione un tipo';
                }
              },
              items: categories
                  .map((category) => DropdownMenuItem(
                        child: Text(category['name']),
                        value: category['id'],
                      ))
                  .toList(),
              onChanged: (value) {
                document['category'] = value as String;
              }),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: document['amount'],
            onChanged: (value) => document['amount'] = value,
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
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: expensesSvc.isSaving
                    ? null
                    : () async {
                        if (!form.isValidForm()) return;
                        final data = Expense(
                            cost: int.parse(document['amount']),
                            date: DateTime.now().toIso8601String(),
                            description: document['category'],
                            quantity: 1);
                        await expensesSvc.addExpense(data);
                        final currentMonth = balanceSvc.getCurrentMonth();
                        await balanceSvc.getBalance(currentMonth);
                        final obj = balanceSvc.balance;
                        obj['expense']['value'] += data.cost;
                        obj['expense']['observation'] = data.date;
                        obj['balance']['value'] =
                            obj['revenue']['value'] - obj['expense']['value'];
                        obj['balance']['observation'] = data.date;
                        await balanceSvc.saveTotals(currentMonth, obj);
                        Navigator.pop(context);
                      },
                child: expensesSvc.isSaving
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
              )),
        ],
      ),
    );
  }
}
