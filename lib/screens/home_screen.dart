import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_tracker_app/screens/setting_screen.dart';
import '../models/item_model.dart';
import 'add_item_screen.dart';
import 'package:quickalert/quickalert.dart';
import '../widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Box itemsBox;

  @override
  void initState() {
    super.initState();
    itemsBox = Hive.box('itemsBox');
    _calculateUsedStorage();
    
  }

  ///green إظهار تحذير عند امتلاء المساحة
  void _showStorageWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('⚠️ تحذير: المساحة على وشك الامتلاء!'),
          content: Text(
            'لقد استخدمت 90% من المساحة المخصصة للتخزين. يُفضل حذف بعض البيانات أو زيادة الحد الأقصى من الإعدادات.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }

  ///blue حساب المساحة المستخدمة والتحقق من تجاوز الحد
  Future<int> _calculateUsedStorage() async {
    final prefs = await SharedPreferences.getInstance();
    int storageLimit = prefs.getInt('storageLimit') ?? 50;
    int totalSize = 0;

    for (var item in itemsBox.values) {
      totalSize += item.toString().length;
    }

    int usedSpace = (totalSize / 1024 / 1024).ceil();

    if (usedSpace >= (storageLimit * 0.9).ceil()) {
      _showStorageWarning();
    }

    return usedSpace;
  }

  ///yellow إظهار حوار عند امتلاء المساحة المخصصة
  void _showStorageLimitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تحذير'),
          content: Text('المساحة المخصصة للتخزين ممتلئة! الرجاء حذف بعض البيانات أو زيادة السعة من الإعدادات.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }

  ///white نافذة تعديل العناصر
  void _showEditDialog(BuildContext context, ItemModel item, int index) {
    final nameController = TextEditingController(text: item.name);
    final priceController = TextEditingController(text: item.price.toString());
    final dateController = TextEditingController(text: item.date);
    final providerController = TextEditingController(text: item.provider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تعديل العنصر',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                SizedBox(height: 16),
                _buildTextField(nameController, 'اسم العنصر'),
                _buildTextField(priceController, 'السعر', keyboardType: TextInputType.number),
                _buildTextField(providerController, 'بيان المورد'),
                _buildTextField(dateController, 'التاريخ'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      item.name = nameController.text;
                      item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
                      item.date = dateController.text;
                      item.provider = providerController.text;
                      itemsBox.putAt(index, item);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('حفظ التغييرات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, 
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///## إنشاء حقول الإدخال الموحدة
  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text(
            'إدارة الأسعار',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        elevation: 0,
      ),
       endDrawer: Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 80, color: Colors.white),
              SizedBox(height: 10),
              Text(
                'مرحبًا بك!',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
                    Directionality(
                textDirection: TextDirection.rtl, // هنا التعديل لضبط الاتجاه
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('الرئيسية'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 10), // مسافة بين العناصر

              Directionality(
                textDirection: TextDirection.rtl, // هنا التعديل لضبط الاتجاه
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('الإعدادات'),
                    onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                    },
                ),
              ),
              SizedBox(height: 10),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('حول التطبيق'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 10),
              Divider(), // خط فاصل بين العناصر
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
      ]),
            
      ),]
        ),
      
    
  ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: itemsBox.listenable(),
                builder: (context, Box box, _) {
                  List<ItemModel> items = box.values
                      .cast<ItemModel>()
                      .where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildItemTile(item, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          int storageLimit = prefs.getInt('storageLimit') ?? 50;
          int usedSpace = await _calculateUsedStorage();

          if (usedSpace >= storageLimit) {
            _showStorageLimitDialog();
            return;
          }

          final newItem = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemScreen()));

          if (newItem != null) {
            itemsBox.add(newItem);
          }
        },
        child: Icon(Icons.add_rounded, size: 30),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'بحث عن صنف...',
        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildItemTile(ItemModel item, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: ListTile(
        title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text('السعر: ${item.price} | المورد: ${item.provider} | التاريخ: ${item.date} | التصنيف: ${item.category}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              title: "تأكيد الحذف",
              text: "هل أنت متأكد ياغالي أنك تريد حذف هذا العنصر؟",
              confirmBtnText: "نعم",
              cancelBtnText: "إلغاء",
              confirmBtnColor: Colors.redAccent,
              onConfirmBtnTap: () {
          itemsBox.deleteAt(index);
          Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  /// إظهار تأكيد تسجيل الخروج
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تأكيد تسجيل الخروج'),
          content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add your logout logic here
              },
              child: Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:price_tracker_app/screens/setting_screen.dart';
// import '../models/item_model.dart';
// import 'add_item_screen.dart';
// import 'package:quickalert/quickalert.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Box itemsBox;

//   @override
//   void initState() {
//     super.initState();
//     itemsBox = Hive.box('itemsBox');
//     _calculateUsedStorage();
//   }

//   void _showStorageWarning() {
//     QuickAlert.show(
//       context: context,
//       type: QuickAlertType.warning,
//       title: '⚠️ تحذير',
//       text: 'لقد استخدمت 90% من المساحة المخصصة للتخزين. يُفضل حذف بعض البيانات أو زيادة الحد الأقصى من الإعدادات.',
//     );
//   }

//   Future<int> _calculateUsedStorage() async {
//     final prefs = await SharedPreferences.getInstance();
//     int storageLimit = prefs.getInt('storageLimit') ?? 50;
//     int totalSize = 0;

//     for (var item in itemsBox.values) {
//       totalSize += item.toString().length;
//     }

//     int usedSpace = (totalSize / 1024 / 1024).ceil();

//     if (usedSpace >= (storageLimit * 0.9).ceil()) {
//       _showStorageWarning();
//     }

//     return usedSpace;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen())),
//           ),
//         ],
//         backgroundColor: Colors.blueAccent,
//         title: Center(
//           child: Text(
//             'إدارة الأسعار',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildSearchField(),
//             SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: itemsBox.listenable(),
//                 builder: (context, Box box, _) {
//                   List<ItemModel> items = box.values
//                       .cast<ItemModel>()
//                       .where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) => _buildItemTile(items[index], index),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final prefs = await SharedPreferences.getInstance();
//           int storageLimit = prefs.getInt('storageLimit') ?? 50;
//           int usedSpace = await _calculateUsedStorage();

//           if (usedSpace >= storageLimit) {
//             _showStorageWarning();
//             return;
//           }

//           final newItem = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddItemScreen()),
//           );

//           if (newItem != null) {
//             itemsBox.add(newItem);
//           }
//         },
//         child: Icon(Icons.add_rounded, size: 30),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       decoration: InputDecoration(
//         labelText: 'بحث عن صنف...',
//         prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//       onChanged: (value) => setState(() {}),
//     );
//   }

//   Widget _buildItemTile(ItemModel item, int index) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(item.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         subtitle: Text('السعر: ${item.price} - المورد: ${item.provider}'),
//         trailing: IconButton(
//           icon: Icon(Icons.edit, color: Colors.blueAccent),
//           onPressed: () => showDialog(
//             context: context,
//             builder: (context) => AddItemScreen(item: item, index: index, box: itemsBox),
//           ),
//         ),
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:price_tracker_app/screens/setting_screen.dart';
// import '../models/item_model.dart';
// import 'add_item_screen.dart';
// import 'package:quickalert/quickalert.dart';


// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Box itemsBox;

//   @override
//   void initState() {
//     super.initState();
//     itemsBox = Hive.box('itemsBox');
//     _calculateUsedStorage();
//   }

//   void _showStorageWarning() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('⚠️ ⚠️ تحذير: نجيب المساحة على وشك الامتلاء !'),
//           content: Text(
//             'لقد استخدمت 90% من المساحة المخصصة للتخزين. يُفضل حذف بعض البيانات أو زيادة الحد الأقصى من الإعدادات.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('حسنًا'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<int> _calculateUsedStorage() async {
//     final prefs = await SharedPreferences.getInstance();
//     int storageLimit = prefs.getInt('storageLimit') ?? 50;
//     int totalSize = 0;

//     for (var item in itemsBox.values) {
//       totalSize += item.toString().length;
//     }

//     int usedSpace = (totalSize / 1024 / 1024).ceil();

//     if (usedSpace >= (storageLimit * 0.9).ceil()) {
//       _showStorageWarning();
//     }

//     return usedSpace;
//   }

//   void _showStorageLimitDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('تحذير'),
//           content: Text('المساحة المخصصة للتخزين ممتلئة! الرجاء حذف بعض البيانات أو زيادة السعة من الإعدادات.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('حسنًا'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditDialog(BuildContext context, ItemModel item, int index) {
//     final nameController = TextEditingController(text: item.name);
//     final priceController = TextEditingController(text: item.price.toString());
//     final dateController = TextEditingController(text: item.date);
//     final providerController = TextEditingController(text: item.provider);

//     //### Covert Into A class widget
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 16,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'تعديل العنصر',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//                 ),
//                 SizedBox(height: 16),
//                 _buildTextField(nameController, 'اسم العنصر'),
//                 _buildTextField(priceController, 'السعر', keyboardType: TextInputType.number),
//                 _buildTextField(providerController, 'بيان المورد'),
//                 _buildTextField(dateController, 'التاريخ'),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       item.name = nameController.text;
//                       item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
//                       item.date = dateController.text;
//                       item.provider = providerController.text;
//                       itemsBox.putAt(index, item);
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: Text('حفظ التغييرات'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent, 
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey[100],
//         ),
//         keyboardType: keyboardType,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingsScreen()),
//               );
//             },
//           ),
//         ],
//         backgroundColor: Colors.blueAccent,
//         title: Center(
//           child: Text(
//             'إدارة الأسعار',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildSearchField(),
//             SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: itemsBox.listenable(),
//                 builder: (context, Box box, _) {
//                   List<ItemModel> items = box.values
//                       .cast<ItemModel>()
//                       .where((item) =>
//                           item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return _buildItemTile(item, index);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final prefs = await SharedPreferences.getInstance();
//           int storageLimit = prefs.getInt('storageLimit') ?? 50;
//           int usedSpace = await _calculateUsedStorage();

//           if (usedSpace >= storageLimit) {
//             _showStorageLimitDialog();
//             return;
//           }

//           final newItem = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddItemScreen()),
//           );

//           if (newItem != null) {
//             itemsBox.add(newItem);
//           }
//         },
//         child: Icon(Icons.add_rounded, size: 30),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       decoration: InputDecoration(
//         labelText: 'بحث عن صنف...',
//         prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//       onChanged: (value) {
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildItemTile(ItemModel item, int index) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10),
//       elevation: 5,
//       child: ListTile(
//         contentPadding: EdgeInsets.all(15),
//         title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         subtitle: Text(
//             'السعر: ${item.price}   | بيان المورد : ${item.provider} | التاريخ: ${item.date}',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600],fontFamily: 'NotoKufiArabic-Bold')),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit, color: Colors.blueAccent),
//               onPressed: () {
//                 _showEditDialog(context, item, index);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.redAccent),
//               onPressed: () {
//                 QuickAlert.show(
//             context: context,
//             type: QuickAlertType.confirm,
//             title:"🙂🙂 متأكد ياغالي",
//             text: "هل تريد بالفعل حذف هذا النتج !؟",
//             confirmBtnText: "نعم",
//             cancelBtnText: "إلغاء",
//             confirmBtnColor: Colors.green,
//             onCancelBtnTap: () 
//             {
//               Navigator.pop(context);
//             },
//             onConfirmBtnTap: () async 
//             {
//                 itemsBox.deleteAt(index);
//                 Navigator.pop(context);
//             },
//               );}
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:price_tracker_app/screens/setting_screen.dart';
// import '../models/item_model.dart';
// import 'add_item_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Box itemsBox;

//   void _showStorageWarning() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('⚠️ تحذير: المساحة على وشك الامتلاء!'),
//           content: Text(
//             'لقد استخدمت 90% من المساحة المخصصة للتخزين. يُفضل حذف بعض البيانات أو زيادة الحد الأقصى من الإعدادات.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('حسنًا'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<int> _calculateUsedStorage() async {
//     final prefs = await SharedPreferences.getInstance();
//     int storageLimit = prefs.getInt('storageLimit') ?? 50; // الحد الأقصى (MB)
//     int totalSize = 0;

//     for (var item in itemsBox.values) {
//       totalSize += item.toString().length; // حساب الحجم بالنصوص
//     }

//     int usedSpace = (totalSize / 1024 / 1024).ceil(); // تحويل الحجم إلى MB

//     // ⚠ إذا وصلت المساحة إلى 90% من الحد الأقصى، أظهر تحذيرًا
//     if (usedSpace >= (storageLimit * 0.9).ceil()) {
//       _showStorageWarning();
//     }

//     return usedSpace;
//   }

//   void _showStorageLimitDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('تحذير'),
//           content: Text('المساحة المخصصة للتخزين ممتلئة! الرجاء حذف بعض البيانات أو زيادة السعة من الإعدادات.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('حسنًا'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     itemsBox = Hive.box('itemsBox');
//     _calculateUsedStorage(); // تحقق من المساحة عند بدء التطبيق
//   }

//   void _showEditDialog(BuildContext context, ItemModel item, int index) {
//     final nameController = TextEditingController(text: item.name);
//     final priceController = TextEditingController(text: item.price.toString());
//     final dateController = TextEditingController(text: item.date);
//     final providerController = TextEditingController(text: item.provider);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 16,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'تعديل العنصر',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//                 ),
//                 SizedBox(height: 16),
//                 _buildTextField(nameController, 'اسم العنصر'),
//                 _buildTextField(priceController, 'السعر', keyboardType: TextInputType.number),
//                 _buildTextField(providerController, 'بيان المورد'),
//                 _buildTextField(dateController, 'التاريخ'),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       item.name = nameController.text;
//                       item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
//                       item.date = dateController.text;
//                       item.provider = providerController.text;
//                       itemsBox.putAt(index, item); // تحديث العنصر في قاعدة البيانات
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: Text('حفظ التغييرات'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent, 
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey[100],
//         ),
//         keyboardType: keyboardType,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//   IconButton(
//     icon: Icon(Icons.settings),//blue زر إضافة ايقونة الاعدادات
//     onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SettingsScreen()),
//       );
//     },
//   ),
// ],
//         backgroundColor: Colors.blueAccent,
//         title: Center(
//           child: Text(
//             'إدارة الأسعار',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildSearchField(),
//             SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: itemsBox.listenable(),
//                 builder: (context, Box box, _) {
//                   List<ItemModel> items = box.values
//                       .cast<ItemModel>()
//                       .where((item) =>
//                           item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return _buildItemTile(item, index);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final prefs = await SharedPreferences.getInstance();
//           int storageLimit = prefs.getInt('storageLimit') ?? 50; // الحد الأقصى المخزن
//           int usedSpace = await _calculateUsedStorage(); // حساب المساحة المستخدمة

//           if (usedSpace >= storageLimit) {
//             _showStorageLimitDialog();
//             return;
//           }

//           final newItem = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddItemScreen()),
//           );

//           if (newItem != null) {
//             itemsBox.add(newItem);
//           }
//         },
//         child: Icon(Icons.add_rounded, size: 30),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       decoration: InputDecoration(
//         labelText: 'بحث عن صنف...',
//         prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//       onChanged: (value) {
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildItemTile(ItemModel item, int index) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10),
//       elevation: 5,
//       child: ListTile(
//         contentPadding: EdgeInsets.all(15),
//         title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         subtitle: Text(
//             'السعر: ${item.price}   | بيان المورد : ${item.provider} | التاريخ: ${item.date}',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit, color: Colors.blueAccent),
//               onPressed: () {
//                 _showEditDialog(context, item, index);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.redAccent),
//               onPressed: () {
//                 itemsBox.deleteAt(index);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:price_tracker_app/screens/setting_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/item_model.dart';
// import 'add_item_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Box itemsBox;


// void _showStorageWarning() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('⚠️ تحذير: المساحة على وشك الامتلاء!'),
//         content: Text(
//           'لقد استخدمت 90% من المساحة المخصصة للتخزين. يُفضل حذف بعض البيانات أو زيادة الحد الأقصى من الإعدادات.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('حسنًا'),
//           ),
//         ],
//       );
//     },
//   );
// }



// Future<int> _calculateUsedStorage() async {
//   final prefs = await SharedPreferences.getInstance();
//   int storageLimit = prefs.getInt('storageLimit') ?? 50; // الحد الأقصى (MB)
//   int totalSize = 0;

//   for (var item in itemsBox.values) {
//     totalSize += item.toString().length; // حساب الحجم بالنصوص
//   }

//   int usedSpace = (totalSize / 1024 / 1024).ceil(); // تحويل الحجم إلى MB

//   // ⚠ إذا وصلت المساحة إلى 90% من الحد الأقصى، أظهر تحذيرًا
//   if (usedSpace >= (storageLimit * 0.9).ceil()) {
//     _showStorageWarning();
//   }

//   return usedSpace;
// }

// void _showStorageLimitDialog() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('تحذير'),
//         content: Text('المساحة المخصصة للتخزين ممتلئة! الرجاء حذف بعض البيانات أو زيادة السعة من الإعدادات.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('حسنًا'),
//           ),
//         ],
//       );
//     },
//   );
// }


//   @override
//   void initState() {
//     super.initState();
//     itemsBox = Hive.box('itemsBox');
//      _calculateUsedStorage(); //green ✅ تحقق من المساحة عند بدء التطبيق
//   }

//   void _showEditDialog(BuildContext context, ItemModel item, int index) {
//     final nameController = TextEditingController(text: item.name);
//     final priceController = TextEditingController(text: item.price.toString());
//     final dateController = TextEditingController(text: item.date);
//     final providerController = TextEditingController(text: item.provider);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 16,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'تعديل العنصر',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//                 ),
//                 SizedBox(height: 16),
//                 _buildTextField(nameController, 'اسم العنصر'),
//                 _buildTextField(priceController, 'السعر', keyboardType: TextInputType.number),
//                 _buildTextField(providerController, 'بيان المورد'),
//                 _buildTextField(dateController, 'التاريخ'),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       item.name = nameController.text;
//                       item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
//                       item.date = dateController.text;
//                       item.provider = providerController.text;
//                       itemsBox.putAt(index, item); // تحديث العنصر في قاعدة البيانات
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: Text('حفظ التغييرات'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent, 
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey[100],
//         ),
//         keyboardType: keyboardType,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//   IconButton(
//     icon: Icon(Icons.settings),//blue زر إضافة ايقونة الاعدادات
//     onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SettingsScreen()),
//       );
//     },
//   ),
// ],
//         backgroundColor: Colors.blueAccent,
//         title: Center(
//           child: Text(
//             'إدارة الأسعار',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildSearchField(),
//             SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: itemsBox.listenable(),
//                 builder: (context, Box box, _) {
//                   List<ItemModel> items = box.values
//                       .cast<ItemModel>()
//                       .where((item) =>
//                           item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return _buildItemTile(item, index);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//   onPressed: () async {
//     final prefs = await SharedPreferences.getInstance();
//     int storageLimit = prefs.getInt('storageLimit') ?? 50; // الحد الأقصى المخزن
//     int usedSpace = await _calculateUsedStorage(); // حساب المساحة المستخدمة

//     if (usedSpace >= storageLimit) {
//       _showStorageLimitDialog();
//       return;
//     }

//     final newItem = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AddItemScreen()),
//     );

//     if (newItem != null) {
//       itemsBox.add(newItem);
//     }
//   },
//   child: Icon(Icons.add_rounded, size: 30),
//   backgroundColor: Colors.green,
// ),

//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       decoration: InputDecoration(
//         labelText: 'بحث عن صنف...',
//         prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//       onChanged: (value) {
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildItemTile(ItemModel item, int index) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10),
//       elevation: 5,
//       child: ListTile(
//         contentPadding: EdgeInsets.all(15),
//         title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         subtitle: Text(
//             'السعر: ${item.price}   | بيان المورد : ${item.provider} | التاريخ: ${item.date}',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit, color: Colors.blueAccent),
//               onPressed: () {
//                 _showEditDialog(context, item, index);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.redAccent),
//               onPressed: () {
//                 itemsBox.deleteAt(index);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/item_model.dart';
// import 'add_item_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Box itemsBox;

//   @override
//   void initState() {
//     super.initState();
//     itemsBox = Hive.box('itemsBox');
//   }

//   void _showEditDialog(BuildContext context, ItemModel item, int index) {
//     final nameController = TextEditingController(text: item.name);
//     final priceController = TextEditingController(text: item.price.toString());
//     final dateController = TextEditingController(text: item.date);
//     final providerController = TextEditingController(text: item.provider);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 16,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'تعديل العنصر',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//                 ),
//                 SizedBox(height: 16),
//                 _buildTextField(nameController, 'اسم العنصر'),
//                 _buildTextField(priceController, 'السعر', keyboardType: TextInputType.number),
//                 _buildTextField(providerController, 'بيان المورد'),
//                 _buildTextField(dateController, 'التاريخ'),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       item.name = nameController.text;
//                       item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
//                       item.date = dateController.text;
//                       item.provider = providerController.text;
//                       itemsBox.putAt(index, item); // تحديث العنصر في قاعدة البيانات
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: Text('حفظ التغييرات'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent, 
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey[100],
//         ),
//         keyboardType: keyboardType,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: Center(
//           child: Text(
//             'إدارة الأسعار',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildSearchField(),
//             SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: itemsBox.listenable(),
//                 builder: (context, Box box, _) {
//                   List<ItemModel> items = box.values
//                       .cast<ItemModel>()
//                       .where((item) =>
//                           item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return _buildItemTile(item, index);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final newItem = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddItemScreen()),
//           );

//           if (newItem != null) {
//             itemsBox.add(newItem);
//           }
//         },
//         child: Icon(Icons.add_rounded, size: 30),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       decoration: InputDecoration(
//         labelText: 'بحث عن صنف...',
//         prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//       onChanged: (value) {
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildItemTile(ItemModel item, int index) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10),
//       elevation: 5,
//       child: ListTile(
//         contentPadding: EdgeInsets.all(15),
//         title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         subtitle: Text(
//             'السعر: ${item.price}   | بيان المورد : ${item.provider} | التاريخ: ${item.date}',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit, color: Colors.blueAccent),
//               onPressed: () {
//                 _showEditDialog(context, item, index);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.redAccent),
//               onPressed: () {
//                 itemsBox.deleteAt(index);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/item_model.dart';
// import 'add_item_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Box itemsBox;

//   @override
//   void initState() {
//     super.initState();
//     itemsBox = Hive.box('itemsBox');
//   }

//   void _showEditDialog(BuildContext context, ItemModel item, int index) {
//     final nameController = TextEditingController(text: item.name);
//     final priceController = TextEditingController(text: item.price.toString());
//     final dateController = TextEditingController(text: item.date);
//     final providerController = TextEditingController(text: item.provider);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('تعديل العنصر'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(hintText: 'اسم العنصر'),
//               ),
//               TextField(
//                 controller: priceController,
//                 decoration: InputDecoration(hintText: 'السعر'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: providerController,
//                 decoration: InputDecoration(hintText: 'بيان المورد'),
//               ),
//               TextField(
//                 controller: dateController,
//                 decoration: InputDecoration(hintText: 'التاريخ'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   item.name = nameController.text;
//                   item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
//                   item.date = dateController.text;
//                   item.provider = providerController.text;
//                   itemsBox.putAt(index, item); // تحديث العنصر في قاعدة البيانات
//                 });
//                 Navigator.pop(context); // إغلاق الDialog
//               },
//               child: Text('حفظ'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             'إدارة الأسعار',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'بحث عن صنف...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ValueListenableBuilder(
//                 valueListenable: itemsBox.listenable(),
//                 builder: (context, Box box, _) {
//                   List<ItemModel> items = box.values
//                       .cast<ItemModel>()
//                       .where((item) =>
//                           item.name.contains(_searchController.text))
//                       .toList();

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return ListTile(
//                         title: Text(item.name),
//                         subtitle: Text(
//                             'السعر: ${item.price}   | بيان المورد : ${item.provider} | التاريخ: ${item.date}'),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // زر التعديل
//                             IconButton(
//                               icon: Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () {
//                                 _showEditDialog(context, item, index);
//                               },
//                             ),
//                             // زر الحذف
//                             IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 box.deleteAt(index);
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final newItem = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddItemScreen()),
//           );

//           if (newItem != null) {
//             itemsBox.add(newItem);
//           }
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
