import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:price_tracker_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';
import 'package:quickalert/quickalert.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late Box itemsBox;

  List<String> _categories = [
    'مواد الصيانة والبناء',
    'أدوات ومواد مسابح',
    'أدوات مكتبية'
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    itemsBox = Hive.box('itemsBox');
    _loadCategories();
  }

  void _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _categories = prefs.getStringList('categories') ?? _categories;
      _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
    });
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Text(
            "إضافة تصنيف",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              hintText: "أدخل اسم التصنيف",
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.blue[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إلغاء",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              onPressed: () async {
                String newCategory = _categoryController.text.trim();
                if (newCategory.isNotEmpty &&
                    !_categories.contains(newCategory)) {
                  setState(() {
                    _categories.add(newCategory);
                    _selectedCategory = newCategory;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setStringList('categories', _categories);

                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: "تمت الإضافة",
                    text: "تمت إضافة التصنيف بنجاح!",
                  );
                }
                Navigator.pop(context);
              },
              child: Text("إضافة"),
            ),
          ],
        );
      },
    );
  }

  void _addItemIfNotExists(ItemModel newItem) async {
    if (newItem.name.isEmpty ||
        newItem.price.isEmpty ||
        newItem.provider.isEmpty ||
        newItem.date.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: ' 😱😱 ماذا تفعل يانجيب  ',
        text: '😅😅 لازم مانخلي الخانات فاضية ',
      );
      return;
    }

    bool itemExists = itemsBox.values.any((existingItem) =>
        existingItem.name == newItem.name &&
        existingItem.price == newItem.price &&
        existingItem.date == newItem.date &&
        existingItem.provider == newItem.provider);

    if (itemExists) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: "🤔 المنتج موجود مسبقًا",
        text: "هل ترغب في إضافته مجددًا؟",
        confirmBtnText: "نعم، أضفه",
        cancelBtnText: "إلغاء",
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () => Navigator.pop(context),
        onConfirmBtnTap: () async {
          itemsBox.add(newItem);
          _showSuccessToast();
          await _syncIfEnabled(newItem);
          _closeScreen();
        },
      );
    } else {
      itemsBox.add(newItem);
      _showSuccessToast();
      await _syncIfEnabled(newItem);
      _closeScreen();
    }
  }

  Future<void> _syncIfEnabled(ItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    bool autoSync = prefs.getBool('autoSync') ?? false;
    if (autoSync) {
      await DatabaseService().syncDataToCloud(item);
    }
  }

  void _showSuccessToast() {
    Fluttertoast.showToast(
      msg: "✅ تمت إضافة العنصر بنجاح",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _closeScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'إضافة صنف جديد',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'اسم الصنف'),
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
                decoration: InputDecoration(labelText: 'المورد'),
              ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'التصنيف',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
                items: _categories
                  .map((category) => DropdownMenuItem(
                      value: category,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                        category,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.black),
                        onSelected: (value) async {
                          if (value == 'edit') {
                          _categoryController.text = category;
                          showDialog(
                            context: context,
                            builder: (context) {
                            return AlertDialog(
                              title: Text("تعديل التصنيف"),
                              content: TextField(
                              controller: _categoryController,
                              decoration: InputDecoration(
                                hintText: "أدخل اسم التصنيف الجديد",
                              ),
                              ),
                              actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("إلغاء"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                String updatedCategory = _categoryController.text.trim();
                                if (updatedCategory.isNotEmpty &&
                                  !_categories.contains(updatedCategory)) {
                                  setState(() {
                                  int index = _categories.indexOf(category);
                                  _categories[index] = updatedCategory;
                                  if (_selectedCategory == category) {
                                    _selectedCategory = updatedCategory;
                                  }
                                  });
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setStringList('categories', _categories);
                                  Navigator.pop(context);
                                }
                                },
                                child: Text("حفظ"),
                              ),
                              ],
                            );
                            },
                          );
                          } else if (value == 'delete') {
                          setState(() {
                            _categories.remove(category);
                            if (_selectedCategory == category) {
                            _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
                            }
                          });
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setStringList('categories', _categories);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                          value: 'edit',
                          child: Text('تعديل'),
                          ),
                          PopupMenuItem(
                          value: 'delete',
                          child: Text('حذف'),
                          ),
                        ],
                        ),
                      ],
                      ),
                    ))
                  .toList(),
                onChanged: (value) {
                  setState(() {
                  _selectedCategory = value!;
                  });
                },
                hint: Text(
                  'اختر تصنيفًا',
                  style: TextStyle(color: Colors.grey),
                ),
                ),
              SizedBox(height: 10),
              TextButton.icon(
                icon: Icon(Icons.add),
                label: Text("إضافة تصنيف جديد"),
                onPressed: _showAddCategoryDialog,
              ),
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
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('اختيار التاريخ'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newItem = ItemModel(
                    name: _nameController.text.trim(),
                    price: _priceController.text.trim(),
                    date: selectedDate.toIso8601String().split('T')[0],
                    provider: _providerController.text.trim(),
                    category: _selectedCategory ?? '',
                  );
                  _addItemIfNotExists(newItem);
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
      ),
    );
  }
}
