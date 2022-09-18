import 'dart:async';
import 'package:balance_app/models/pocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PocketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Pocket>> pocketStream() {
    return _firestore
        .collection('pockets')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Pocket> retVal = [];
      query.docs.forEach((doc) {
        final pocket = doc.data() as Map<String, dynamic>;
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
      (id == null || id.isEmpty)
          ? await instance.add(data.toJson())
          : await instance.doc(id).set(data.toJson());
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
