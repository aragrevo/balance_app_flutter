import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesService {
  final CollectionReference _instance =
      FirebaseFirestore.instance.collection('categories');

  Future<List<dynamic>> getCategories(String type) async {
    List<dynamic> categories = [];
    QuerySnapshot querySnapshot =
        await _instance.where('type', isEqualTo: type).get();
    // ignore: avoid_function_literals_in_foreach_calls
    querySnapshot.docs.forEach((doc) {
      final category = doc.data() as Map<String, dynamic>;
      final list = category['categories'];
      categories.addAll(list);
    });
    return categories;
  }
}
