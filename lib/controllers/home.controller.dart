import 'package:balance_app/services/balance.service.dart';
import 'package:balance_app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final RxList<String> _months = RxList<String>();
  var currentIndex = 0.obs;
  var searching = false.obs;

  List<String> get months {
    // ignore: invalid_use_of_protected_member
    final m = _months.value.map((e) => formattedDate(e)).toList();
    m.sort(
        (a, b) => transformStringToDate(a).compareTo(transformStringToDate(b)));
    return m.reversed.toList();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();
    _months.bindStream(BalanceService().dataStream());
  }

  changePage(int page) {
    currentIndex.value = page;
  }

  void openSettingsDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  void closeSettingsDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  String formattedDate(String value) {
    final date = value.split('_')[0];
    final month = date.substring(0, date.length - 4).toCapitalize;
    final year = date.substring(date.length - 4);
    return '$month $year';
  }

  DateTime transformStringToDate(String date) {
    return DateFormat('MMMM yyyy').parse(date);
  }
}
