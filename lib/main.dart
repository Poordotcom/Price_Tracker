import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/item_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ItemModelAdapter());
  await Hive.openBox('itemsBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFF0069C0), // الأزرق الأساسي
        colorScheme: ThemeData.light().colorScheme.copyWith(
          background: Colors.white,
          primary: Color(0xFF0069C0),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0069C0),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0088D1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0069C0),
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          background: Color(0xFF121212),
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0069C0),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0088D1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

















// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'screens/home_screen.dart';
// import 'package:hive/hive.dart';
// import 'models/item_model.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(ItemModelAdapter());
//   await Hive.openBox('itemsBox');
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith(
//         primaryColor: Color(0xFF0069C0), // الأزرق الأساسي
//         colorScheme: ThemeData.light().colorScheme.copyWith(
//           background: Colors.white,
//           primary: Color(0xFF0069C0), // الأزرق الأساسي
//         ),
//         scaffoldBackgroundColor: Color(0xFFF5F5F5), // خلفية فاتحة
//         appBarTheme: AppBarTheme(
//           backgroundColor: Color(0xFF0069C0), // الأزرق
//           elevation: 0,
//           centerTitle: true,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF0088D1), // لون الزر: أزرق فاتح
//             foregroundColor: Colors.white, // النص باللون الأبيض
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           ),
//         ),
//         textTheme: TextTheme(
//           bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
//           bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
//         ),
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         primaryColor: Color(0xFF0069C0), // الأزرق الأساسي
//         colorScheme: ThemeData.dark().colorScheme.copyWith(
//           background: Color(0xFF121212), // خلفية داكنة
//         ),
//         scaffoldBackgroundColor: Color(0xFF121212), // خلفية داكنة
//         appBarTheme: AppBarTheme(
//           backgroundColor: Color(0xFF0069C0), // الأزرق
//           elevation: 0,
//           centerTitle: true,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF0088D1), // أزرق فاتح
//             foregroundColor: Colors.white, // النص باللون الأبيض
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           ),
//         ),
//         textTheme: TextTheme(
//           bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
//           bodyMedium: TextStyle(color: Colors.white54, fontSize: 14),
//         ),
//       ),
//       themeMode: ThemeMode.system, // الوضع حسب إعدادات النظام (فاتح أو داكن)
//       home: HomeScreen(),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'screens/home_screen.dart';
// import 'package:hive/hive.dart';
//   // تأكد من استخدام الأمر لتوليد ملف .g.dart في الخطوة التالية.

// import 'models/item_model.dart';



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(ItemModelAdapter());  // تسجيل المحول
//   await Hive.openBox('itemsBox'); //## صندوق تخزين البيانات
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith( // الوضع الليلي
//         primaryColor: Colors.blue,
//         colorScheme: ThemeData.dark().colorScheme.copyWith(
//           background: Colors.black,
//         ),
//         scaffoldBackgroundColor: const Color.fromARGB(255, 34, 65, 192),
//       ), // الوضع النهاري
//       darkTheme: ThemeData.dark().copyWith( // الوضع الليلي
//         primaryColor: Colors.blue,
//         colorScheme: ThemeData.dark().colorScheme.copyWith(
//           background: const Color.fromARGB(255, 5, 0, 34),
//         ),
//         scaffoldBackgroundColor: Colors.grey[900],
//       ),
//       themeMode: ThemeMode.light,
//       home: HomeScreen(),
//     );
//   }
// }
