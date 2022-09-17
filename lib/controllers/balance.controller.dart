import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:get/get.dart';

class BalanceController extends GetxController {
  static BalanceController get to => Get.find();
  final RxMap<String, dynamic> _balance = RxMap<String, dynamic>();
  final RxList<Wallet> _wallet = RxList<Wallet>();

  Map<String, dynamic> get balance => _balance.value;
  List<Wallet> get wallet => _wallet.value;

  @override
  void onInit() {
    final monthName = BalanceService().getCurrentMonth();
    _balance.bindStream(BalanceService().balanceStream(monthName));
    _wallet.bindStream(BalanceService().walletStream());
  }
}
