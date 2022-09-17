import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:balance_app/services/categories.service.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _categories = <dynamic>[].obs;
  var type = ''.obs;
  var category = ''.obs;
  var amount = ''.obs;

  List<dynamic> get categories {
    final cat = _categories.value;
    cat.sort(((a, b) => a['name'].compareTo(b['name'])));
    return cat;
  }

  Future<void> getCategories(String type) async {
    try {
      _categories.value = await CategoriesService().getCategories(type);
    } catch (e) {
      Get.defaultDialog(title: 'Error', content: Text(e.toString()));
      _categories.value = [];
    }
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
