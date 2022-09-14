import 'dart:async';
import 'dart:math';

import 'package:balance_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BalanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> balanceStream(String filter) {
    return _firestore.collection('data').doc(filter).snapshots().map((event) {
      final balance = event.data() as Map<String, dynamic>;
      return balance;
    });
  }

  Future<void> saveTotals(String filter, dynamic value) {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    return instance.doc(filter).set(value).then((_) {
      // getBalance(filter);
    });
  }

  String getCurrentMonth() {
    final monthName = DateFormat.MMMM().format(DateTime.now());
    final year = DateTime.now().year;
    return monthName.toLowerCase() + year.toString();
  }
}
