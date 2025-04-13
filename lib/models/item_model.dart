// import 'package:hive/hive.dart';

// part 'item_model.g.dart'; // سيتم إنشاؤه تلقائيًا لاحقًا

// @HiveType(typeId: 0) // تعريف نوع البيانات في Hive
// class ItemModel {
//   @HiveField(0)
//   String name;

//   @HiveField(1)
//   String price;

//   @HiveField(2)
//   String date;

//   @HiveField(3) // إضافة حقل الفئة
//   String category; // فئة العنصر

//   // constructor
//   ItemModel({
//     required this.name,
//     required this.price,
//     required this.date,
//     required this.category, // تم إضافة الفئة
//   });
// }






import 'package:hive/hive.dart';

part 'item_model.g.dart'; // سيتم إنشاؤه تلقائيًا لاحقًا

@HiveType(typeId: 0) // تعريف نوع البيانات في Hive
class ItemModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String price;

  @HiveField(2)
  String date;

  @HiveField(3)
  String provider;
  // @HiveField(4)
  // String category;
  @HiveField(4)
  String category;

  ItemModel({required this.name, required this.price, required this.date, required this.provider,required this.category,});
}



// class ItemModel {
//   String name;
//   String price;
//   String date;

//   ItemModel({required this.name, required this.price, required this.date});

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'date': date,
//     };
//   }

//   factory ItemModel.fromMap(Map<String, dynamic> map) {
//     return ItemModel(
//       name: map['name'],
//       price: map['price'],
//       date: map['date'],
//     );
//   }
// }
