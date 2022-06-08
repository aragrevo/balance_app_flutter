import 'package:balance_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesService with ChangeNotifier {
  final CollectionReference _instance =
      FirebaseFirestore.instance.collection('expenses');
  final List<Expense> _expenses = [];
  var isSaving = false;

  List<Expense> get expensesList => [..._expenses];
  set expensesList(List<Expense> value) {
    _expenses.clear();
    _expenses.addAll(value);
    notifyListeners();
  }

  ExpensesService() {
    getExpenses();
  }

  Future<void> getExpenses() async {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    List<Expense> expensesList = [];
    _instance
        .orderBy('date', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final expense = doc.data() as Map<String, dynamic>;
        final expenseDate = DateTime.parse(expense['date']);
        if (expenseDate.year == year && expenseDate.month == month) {
          expensesList.add(Expense.fromJson(expense));
        }
      });
      this.expensesList = expensesList;
      notifyListeners();
    });
  }

  Future<void> addExpense(Expense expense) async {
    isSaving = true;
    notifyListeners();
    try {
      await _instance.add(expense.toJson());
    } catch (e) {
      print(e);
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
