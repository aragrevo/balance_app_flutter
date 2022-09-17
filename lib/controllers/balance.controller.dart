import 'package:balance_app/models/wallet.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:get/get.dart';

class BalanceController extends GetxController {
  static BalanceController get to => Get.find();
  final RxMap<String, dynamic> _balance = RxMap<String, dynamic>();
  final RxList<Wallet> _wallet = RxList<Wallet>();

  final RxString newValue = ''.obs;

  Map<String, dynamic> get balance => _balance.value;
  List<Wallet> get wallet => _wallet.value;

  @override
  void onInit() {
    final monthName = BalanceService().getCurrentMonth();
    _balance.bindStream(BalanceService().balanceStream(monthName));
    _wallet.bindStream(BalanceService().walletStream());
  }

  Future<void> saveWallet(Wallet wallet) async {
    if (newValue.value.isEmpty) {
      Get.snackbar('Error', 'Can not be empty');
      return;
    }
    wallet.value = int.parse(newValue.value);
    final saved = await BalanceService().saveBalance(wallet.id!, wallet);
    if (saved) {
      Get.back();
    }
  }
}
