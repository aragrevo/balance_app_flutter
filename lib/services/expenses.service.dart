import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/models/log.dart';
import 'package:balance_app/services/auth_service.dart';
import 'package:balance_app/services/log.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balance_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ExpensesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authSvc = Provider.of<AuthService>(Get.context!, listen: false);

  Stream<List<Expense>> expenseStream() {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final money = authSvc.money == Money.eur ? Money.eur.name : null;
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: authSvc.user!.id)
        .where('money', isEqualTo: money)
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Expense> retVal = [];
      query.docs.forEach((doc) {
        final expense = doc.data() as Map<String, dynamic>;
        expense['id'] = doc.id;
        final expenseDate = DateTime.parse(expense['date']);
        if (expenseDate.year == year && expenseDate.month == month) {
          retVal.add(Expense.fromJson(expense));
        }
      });
      return retVal;
    });
  }

  Stream<List<Expense>> expenseHistoryStream() {
    final money = authSvc.money == Money.eur ? Money.eur.name : null;
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: authSvc.user!.id)
        .where('money', isEqualTo: money)
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Expense> retVal = [];
      query.docs.forEach((doc) {
        final expense = doc.data() as Map<String, dynamic>;
        expense['id'] = doc.id;
        retVal.add(Expense.fromJson(expense));
      });
      return retVal;
    });
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final obj = expense.toJson();
      obj['userId'] = authSvc.user!.id;
      obj['money'] = authSvc.money?.name;
      await _firestore.collection('expenses').add(obj);
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      final obj = expense.toJson();
      obj['userId'] = authSvc.user!.id;
      obj['money'] = authSvc.money?.name;
      await _firestore.collection('expenses').doc(expense.id).set(obj);
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool> deleteExpense(String id, Expense data) async {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('expenses');
    try {
      await instance.doc(id).delete();
      data.cost = -1 * data.cost;
      await BalanceController.to.updateBalance(data, 'expense');
      final log = Log(
        value: data.cost,
        name: data.description,
        location: data.description,
        date: DateTime.now().toIso8601String(),
        type: 'expense',
      );
      LogService().saveLog(log);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      return false;
    }
  }
}
