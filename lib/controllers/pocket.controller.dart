import 'package:balance_app/models/log.dart';
import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/services/balance.service.dart';
import 'package:balance_app/services/log.service.dart';
import 'package:balance_app/services/pocket.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PocketController extends GetxController {
  static PocketController get to => Get.find();
  final RxList<Pocket> _pocket = RxList<Pocket>();
  final RxList<Pocket> _pocketRest = RxList<Pocket>();
  final RxList<Pocket> _pocketSave = RxList<Pocket>();

  final RxString newValue = ''.obs;
  final RxString updateValue = ''.obs;
  final restOfBalance = false.obs;
  final isUpdating = false.obs;
  final Rx<Pocket?> pocketToDelete = Rx<Pocket?>(null);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<Pocket> get pocket => _pocket.value;
  List<Pocket> get pocketRest {
    return _getPockets(true);
  }

  List<Pocket> get pocketSaved {
    return _getPockets(false);
  }

  int get totalPocketRest {
    return getTotal(pocketRest);
  }

  int get totalPocketSaved {
    return getTotal(pocketSaved);
  }

  int get totalPockets {
    return getTotal(pocket);
  }

  Map<String, int> get balanceInWallets {
    final res = pocket.fold<Map<String, int>>({}, (previousValue, element) {
      final prev = previousValue[element.location] ?? 0;
      previousValue[element.location] = prev + element.value;
      return previousValue;
    });
    return res;
  }

  @override
  void onInit() {
    _pocket.bindStream(PocketService().pocketStream());
    _pocketRest.bindStream(PocketService().pocketStream());
    _pocketSave.bindStream(PocketService().pocketStream());
  }

  List<Pocket> _getPockets(bool type) {
    final pockets =
        pocket.where((element) => element.restOfBalance == type).toList();
    pockets.sort(((a, b) => a.name.compareTo(b.name)));
    return pockets;
  }

  int getTotal(List<Pocket> pockets) {
    return pockets.fold<int>(
        0, (previousValue, element) => previousValue + element.value);
  }

  Future<void> savePocket(Pocket pocket) async {
    if (newValue.value.isEmpty && isUpdating.value == false) {
      Get.snackbar('Error', 'Value can not be empty',
          backgroundColor: Colors.yellowAccent.withOpacity(0.5));
      return;
    }
    final value =
        updateValue.value.isNotEmpty ? updateValue.value : newValue.value;
    final previousValue = pocket.value;
    pocket.value = int.parse(value);
    pocket.restOfBalance = restOfBalance.value;
    pocket.name = titleController.text;
    pocket.location = locationController.text;
    final saved = await PocketService().savePocket(pocket.id, pocket);
    if (saved) {
      final log = Log(
          value: pocket.value - previousValue,
          name: pocket.name,
          location: pocket.location,
          date: DateTime.now().toIso8601String(),
          type: 'pocket',
          previousValue: previousValue);
      LogService().saveLog(log);
      Get.back();
    }
  }

  void updatePocketValue(Pocket pocket, Operation operation) {
    if (newValue.value.isEmpty) {
      Get.snackbar('Error', 'Value can not be empty',
          backgroundColor: Colors.yellowAccent.withOpacity(0.5));
      return;
    }

    switch (operation) {
      case Operation.sum:
        updateValue.value =
            (pocket.value + int.parse(newValue.value)).toString();
        break;
      case Operation.rest:
        updateValue.value =
            (pocket.value - int.parse(newValue.value)).toString();
        break;
    }

    isUpdating.value = true;
    newValue.value = '';
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    newValue.value = '';
    updateValue.value = '';
    restOfBalance.value = false;
    isUpdating.value = false;
    formKey.currentState?.reset();
  }

  createWallets() {
    BalanceService().addWallets();
  }
}

enum Operation { sum, rest }
