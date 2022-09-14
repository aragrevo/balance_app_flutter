import 'package:balance_app/services/balance.service.dart';
import 'package:get/get.dart';

class BalanceController extends GetxController {
  static BalanceController get to => Get.find();
  final RxMap<String, dynamic> _balance = RxMap<String, dynamic>();

  Map<String, dynamic> get balance => _balance.value;

  @override
  void onInit() {
    final monthName = BalanceService().getCurrentMonth();
    _balance.bindStream(BalanceService().balanceStream(monthName));
  }
}
