import 'package:balance_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesService {
  final CollectionReference _instance =
      FirebaseFirestore.instance.collection('categories');

  Future<List<dynamic>> getCategories(String type) async {
    List<dynamic> categories = [];
    QuerySnapshot querySnapshot =
        await _instance.where('type', isEqualTo: type).get();
    querySnapshot.docs.forEach((doc) {
      final category = doc.data() as Map<String, dynamic>;
      final list = category['categories'];
      categories.addAll(list);
    });
    return categories;
  }
}
