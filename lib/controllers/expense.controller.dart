import 'package:balance_app/models/expense.dart';
import 'package:balance_app/services/expenses.service.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  final RxList<Expense> _expenses = RxList<Expense>();

  List<Expense> get expensesList => _expenses.value;

  @override
  void onInit() {
    _expenses.bindStream(ExpensesService().expenseStream());
  }
}
