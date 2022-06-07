import 'package:balance_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesService with ChangeNotifier {
  final CollectionReference _instance =
      FirebaseFirestore.instance.collection('categories');
  final List<dynamic> _categories = [];

  List<dynamic> get categoriesList => [..._categories];
  set categoriesList(List<dynamic> value) {
    _categories.clear();
    _categories.addAll(value);
    _categories.sort((a, b) => a['name'].compareTo(b['name']));
    notifyListeners();
  }

  CategoriesService() {}

  getCategories(String type) {
    List<dynamic> categories = [];
    _instance
        .where('type', isEqualTo: type)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final category = doc.data() as Map<String, dynamic>;
        final list = category['categories'];
        categories.addAll(list);
      });
      categoriesList = categories;
    });
  }
}
