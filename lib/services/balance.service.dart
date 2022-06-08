import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BalanceService with ChangeNotifier {
  final CollectionReference _instance =
      FirebaseFirestore.instance.collection('balance');
  BalanceService() {
    final String monthName = getCurrentMonth();
    getBalance(monthName);
  }

  dynamic _balance;
  dynamic get balance => _balance;
  set balance(dynamic value) {
    _balance = value;
    notifyListeners();
  }

  Future<void> getBalance(String filter) {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    return instance.doc(filter).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final balance = documentSnapshot.data() as Map<String, dynamic>;
        this.balance = balance;
      }
    });
  }

  Future<void> saveTotals(String filter, dynamic value) {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    return instance.doc(filter).set(value).then((_) {
      getBalance(filter);
    });
  }

  String getCurrentMonth() {
    final monthName = DateFormat.MMMM().format(DateTime.now());
    final year = DateTime.now().year;
    return monthName.toLowerCase() + year.toString();
  }
}
