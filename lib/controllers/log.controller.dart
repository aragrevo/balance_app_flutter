import 'package:balance_app/models/log.dart';
import 'package:balance_app/services/log.service.dart';
import 'package:get/get.dart';

class LogController extends GetxController {
  static LogController get to => Get.find();

  final RxList<Log> _logs = RxList<Log>();
  final RxList<Log> _allLogs = RxList<Log>();
  var type = ''.obs;

  List<Log> get logs {
    // ignore: invalid_use_of_protected_member
    final l = _logs.value.isNotEmpty ? _logs.value : _allLogs.value;
    l.sort((a, b) =>
        transformStringToDate(b.date).compareTo(transformStringToDate(a.date)));
    return l;
  }

  @override
  void onInit() {
    super.onInit();
    _allLogs.bindStream(LogService().logStream());
    filterLogs();
  }

  filterLogs() {
    if (type.value.isEmpty) {
      // ignore: invalid_use_of_protected_member
      _logs.value = _allLogs.value;
    } else {
      // ignore: invalid_use_of_protected_member
      _logs.value = _allLogs.value
          .where((element) => element.type == type.value)
          .toList();
    }
  }

  DateTime transformStringToDate(String date) {
    return DateTime.parse(date);
  }
}
