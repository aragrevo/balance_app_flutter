import 'package:balance_app/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balance_app/models/expense.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RevenuesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authSvc = Provider.of<AuthService>(Get.context!, listen: false);

  Future<void> addRevenue(Expense expense) async {
    try {
      final obj = expense.toJson();
      obj['userId'] = authSvc.user!.id;
      await _firestore.collection('revenues').add(obj);
    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
