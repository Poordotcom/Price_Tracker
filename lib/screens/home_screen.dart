import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';
import 'add_item_screen.dart';

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
  }

  void _showEditDialog(BuildContext context, ItemModel item, int index) {
    final nameController = TextEditingController(text: item.name);
    final priceController = TextEditingController(text: item.price.toString());
    final dateController = TextEditingController(text: item.date);
    final providerController = TextEditingController(text: item.provider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعديل العنصر'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'اسم العنصر'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(hintText: 'السعر'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: providerController,
                decoration: InputDecoration(hintText: 'بيان المورد'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(hintText: 'التاريخ'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  item.name = nameController.text;
                  item.price = (double.tryParse(priceController.text)?.toString() ?? item.price);
                  item.date = dateController.text;
                  item.provider = providerController.text;
                  itemsBox.putAt(index, item); // تحديث العنصر في قاعدة البيانات
                });
                Navigator.pop(context); // إغلاق الDialog
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'إدارة الأسعار',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'بحث عن صنف...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: itemsBox.listenable(),
                builder: (context, Box box, _) {
                  List<ItemModel> items = box.values
                      .cast<ItemModel>()
                      .where((item) =>
                          item.name.contains(_searchController.text))
                      .toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            'السعر: ${item.price}   | بيان المورد : ${item.provider} | التاريخ: ${item.date}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // زر التعديل
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditDialog(context, item, index);
                              },
                            ),
                            // زر الحذف
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                box.deleteAt(index);
                              },
                            ),
                          ],
                        ),
                      );
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
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );

          if (newItem != null) {
            itemsBox.add(newItem);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
