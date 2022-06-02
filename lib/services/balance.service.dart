import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceService with ChangeNotifier {
  final CollectionReference balance =
      FirebaseFirestore.instance.collection('balance');
  BalanceService() {
    getBalance('june2022');
    // print('BalanceService');
  }

  Future<DocumentSnapshot?> getBalance(String filter) {
    // balance.get().then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc.data());
    //   });
    // });
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    return instance.doc(filter).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot;
      }
      return null;
    });
  }
}
