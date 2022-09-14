import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  var currentIndex = 0.obs;

  changePage(int page) {
    currentIndex.value = page;
  }
}
