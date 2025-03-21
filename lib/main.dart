import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'package:hive/hive.dart';
  // تأكد من استخدام الأمر لتوليد ملف .g.dart في الخطوة التالية.

import 'models/item_model.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ItemModelAdapter());  // تسجيل المحول
  await Hive.openBox('itemsBox'); //## صندوق تخزين البيانات
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith( // الوضع الليلي
        primaryColor: Colors.blue,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          background: Colors.black,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 34, 65, 192),
      ), // الوضع النهاري
      darkTheme: ThemeData.dark().copyWith( // الوضع الليلي
        primaryColor: Colors.blue,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          background: const Color.fromARGB(255, 5, 0, 34),
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      themeMode: ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
