import 'dart:async';
import 'package:balance_app/models/balance_detail.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PocketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authSvc = Provider.of<AuthService>(Get.context!, listen: false);
  Stream<List<Pocket>> pocketStream() {
    final money = authSvc.money == Money.eur ? Money.eur.name : null;
    return _firestore
        .collection('pockets')
        .where('userId', isEqualTo: authSvc.user!.id)
        .where('money', isEqualTo: money)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Pocket> retVal = [];
      // ignore: avoid_function_literals_in_foreach_calls
      query.docs.forEach((doc) {
        final pocket = doc.data() as Map<String, dynamic>;
        if (!authSvc.isEuro && pocket['money'] == Money.eur.name) {
          return;
        }
        pocket['id'] = doc.id;
        if (pocket['name'] != null) {
          retVal.add(Pocket.fromJson(pocket));
        }
      });
      return retVal;
    });
  }

  Future<bool> savePocket(String? id, Pocket data) async {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('pockets');
    try {
      final obj = data.toJson();
      obj['userId'] = authSvc.user!.id;
      obj['money'] = authSvc.money?.name;
      (id == null || id.isEmpty)
          ? await instance.add(obj)
          : await instance.doc(id).set(obj);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      return false;
    }
  }

  Future<bool> deletePocket(String id, Pocket data) async {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('pockets');
    try {
      await instance.doc(id).delete();
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      return false;
    }
  }
}
