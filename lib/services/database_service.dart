//### (الخدمات مثل قاعدة البيانات) Database Service
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncDataToCloud(ItemModel item) async {
    await _firestore.collection('items').add({
      'name': item.name,
      'price': item.price,
      'date': item.date,
      'provider': item.provider,
    });
  }
}
