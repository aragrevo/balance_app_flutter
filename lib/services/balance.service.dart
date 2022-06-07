import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BalanceService with ChangeNotifier {
  final CollectionReference _instance =
      FirebaseFirestore.instance.collection('balance');
  BalanceService() {
    final monthName = DateFormat.MMMM().format(DateTime.now());
    final year = DateTime.now().year;
    getBalance(monthName.toLowerCase() + year.toString());
  }

  dynamic _balance;
  dynamic get balance => _balance;
  set balance(dynamic value) {
    _balance = value;
    notifyListeners();
  }

  Future<void> getBalance(String filter) {
    // balance.get().then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc.data());
    //   });
    // });
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    return instance.doc(filter).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final balance = documentSnapshot.data() as Map<String, dynamic>;
        this.balance = balance;
      }
    });
  }
}
