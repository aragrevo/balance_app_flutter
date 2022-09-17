import 'dart:async';
import 'package:balance_app/models/pocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PocketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Pocket>> pocketStream() {
    return _firestore
        .collection('pockets')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Pocket> retVal = [];
      query.docs.forEach((doc) {
        final wallet = doc.data() as Map<String, dynamic>;
        if (wallet['name'] != null) {
          retVal.add(Pocket.fromJson(wallet));
        }
      });
      return retVal;
    });
  }
}
