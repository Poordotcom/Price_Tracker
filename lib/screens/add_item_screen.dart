import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/item_model.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _providerController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late Box itemsBox;

  @override
  void initState() {
    super.initState();
    itemsBox = Hive.box('itemsBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'إضافة صنف جديد',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'اسم الصنف', hintTextDirection: TextDirection.rtl),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'السعر'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
              TextField(
              controller: _providerController,
              decoration: InputDecoration(
                  labelText: 'بيان المورد', hintTextDirection: TextDirection.rtl),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("التاريخ: ${selectedDate.toLocal()}".split(' ')[0]),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate)
                      setState(() {
                        selectedDate = pickedDate;
                      });
                  },
                  child: Text('اختيار التاريخ'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newItem = ItemModel(
                  name: _nameController.text,
                  price: _priceController.text,
                  date: selectedDate.toIso8601String().split('T')[0],
                  provider: _providerController.text,
                );

                itemsBox.add(newItem);
                Navigator.pop(context);
              },
              child: Text(
                'إضافة',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


