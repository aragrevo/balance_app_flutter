import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balance_app/models/expense.dart';

class RevenuesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRevenue(Expense expense) async {
    try {
      await _firestore.collection('revenues').add(expense.toJson());
    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
