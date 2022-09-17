import 'package:balance_app/models/pocket.dart';
import 'package:balance_app/services/pocket.service.dart';
import 'package:get/get.dart';

class PocketController extends GetxController {
  static PocketController get to => Get.find();
  final RxList<Pocket> _pocket = RxList<Pocket>();
  final RxList<Pocket> _pocketRest = RxList<Pocket>();
  final RxList<Pocket> _pocketSave = RxList<Pocket>();

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
}
