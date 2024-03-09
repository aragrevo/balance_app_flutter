import 'dart:async';

import 'package:balance_app/controllers/balance.controller.dart';
import 'package:balance_app/models/balance.dart';
import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BalanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authSvc = Provider.of<AuthService>(Get.context!, listen: false);

  Stream<Balance?> balanceStream(String filter) {
    return _firestore.collection('data').doc(filter).snapshots().map((event) {
      final balance = event.data() as Map<String, dynamic>;
      balance['id'] = event.id;
      try {
        final b = Balance.fromJson(balance);
        return b;
      } catch (e) {
        print(e);
        rethrow;
      }
    });
  }

  Stream<List<String>> dataStream() {
    return _firestore
        .collection('data')
        .where('userId', isEqualTo: authSvc.user!.id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<String> retVal = [];
      // ignore: avoid_function_literals_in_foreach_calls
      query.docs.forEach((doc) {
        retVal.add(doc.id);
      });
      return retVal;
    });
  }

  Stream<List<Wallet>> walletStream() {
    return _firestore
        .collection('balance')
        .where('userId', isEqualTo: authSvc.user!.id)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Wallet> retVal = [];
      // ignore: avoid_function_literals_in_foreach_calls
      query.docs.forEach((doc) {
        final wallet = doc.data() as Map<String, dynamic>;
        if (wallet['wallets'] != null) {
          wallet['wallets'].forEach((w) {
            retVal.add(Wallet.fromJson(w));
          });
        }
      });
      return retVal;
    });
  }

  Future<void> saveTotals(String filter, Balance value) {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    final obj = value.toJson();
    obj['userId'] = authSvc.user!.id;
    return instance.doc(filter).set(obj);
  }

  Future<void> addTotals(Balance value) {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('data');
    final obj = value.toJson();
    obj['userId'] = authSvc.user!.id;
    return instance.doc(value.id).set(obj);
  }

  String getCurrentMonth() {
    final monthName = DateFormat.MMMM().format(DateTime.now());
    final year = DateTime.now().year;
    return '${monthName.toLowerCase()}${year}_${authSvc.user!.id}';
  }

  Future<bool> saveBalance(String id, Wallet data) async {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('balance');
    try {
      final index = BalanceController.to.wallet
          .indexWhere((element) => element.id == data.id);
      final list = BalanceController.to.wallet.map((e) => e.toJson()).toList();
      list[index] = data.toJson();

      final Map<String, dynamic> obj = {
        'wallets': list,
        'userId': authSvc.user!.id
      };
      await instance.doc(obj['userId']).set(obj);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      return false;
    }
  }

  Future<void> addWallets() {
    final CollectionReference instance =
        FirebaseFirestore.instance.collection('balance');
    final list = [
      _buildWallet('card').toJson(),
      _buildWallet('cash').toJson(),
      _buildWallet('mobile').toJson()
    ];
    final Map<String, dynamic> obj = {
      'wallets': list,
      'userId': authSvc.user!.id
    };
    return instance.doc(obj['userId']).set(obj);
  }

  Wallet _buildWallet(String type) {
    return Wallet(value: 0, name: type, icon: type, id: type);
  }
}
