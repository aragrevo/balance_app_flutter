import 'dart:async';
import 'package:balance_app/models/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Log>> logStream() {
    return _firestore
        .collection('logs')
        .orderBy('date', descending: true)
        .limit(100)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Log> retVal = [];
      query.docs.forEach((doc) {
        final log = doc.data() as Map<String, dynamic>;
        try {
          final obj = Log.fromJson(log);
          if (obj.type == '') {
            obj.type = obj.description != null ? 'expense' : 'pocket';
          }
          retVal.add(obj);
        } catch (e) {
          printError(info: e.toString());
        }
      });
      return retVal;
    });
  }

  Future<bool> saveLog(Log data) async {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('logs');
    try {
      await instance.add(data.toJson());

      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      return false;
    }
  }
}
