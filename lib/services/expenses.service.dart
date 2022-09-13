import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balance_app/models/expense.dart';

class ExpensesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Expense>> expenseStream() {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    return _firestore
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Expense> retVal = [];
      query.docs.forEach((doc) {
        final expense = doc.data() as Map<String, dynamic>;
        final expenseDate = DateTime.parse(expense['date']);
        if (expenseDate.year == year && expenseDate.month == month) {
          retVal.add(Expense.fromJson(expense));
        }
      });
      return retVal;
    });
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').add(expense.toJson());
    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
