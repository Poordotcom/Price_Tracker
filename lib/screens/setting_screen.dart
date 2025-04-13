// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';

// // 🔹 مزود الحالة للتحكم في الإعدادات
// class SettingsProvider extends ChangeNotifier {
//   bool _isAutoSyncEnabled = false;
//   bool _isDarkMode = false;
//   late FlutterLocalNotificationsPlugin _notificationsPlugin;

//   bool get isAutoSyncEnabled => _isAutoSyncEnabled;
//   bool get isDarkMode => _isDarkMode;

//   SettingsProvider() {
//     _loadSettings();
//     _initNotifications();
//   }

//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     _isAutoSyncEnabled = prefs.getBool('autoSync') ?? false;
//     _isDarkMode = prefs.getBool('darkMode') ?? false;
//     notifyListeners();
//   }

//   Future<void> _initNotifications() async {
//     _notificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings settings =
//         InitializationSettings(android: androidSettings);

//     await _notificationsPlugin.initialize(settings);
//   }

//   Future<void> _showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'sync_channel',
//       'مزامنة البيانات',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails details = NotificationDetails(android: androidDetails);
//     await _notificationsPlugin.show(0, title, body, details);
//   }

//   Future<void> toggleAutoSync(bool newValue) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('autoSync', newValue);
//     _isAutoSyncEnabled = newValue;
//     notifyListeners();

//     _showNotification(
//       newValue ? '🔄 تم تفعيل المزامنة' : '📴 تم إيقاف المزامنة',
//       newValue ? 'البيانات ستتم مزامنتها تلقائيًا' : ' المزامنة التلقائية متوقفة.',
//     );
//   }

//   Future<void> toggleDarkMode(bool newValue) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('darkMode', newValue);
//     _isDarkMode = newValue;
//     notifyListeners();
//   }
// }

// // 🔹 شاشة الإعدادات الرئيسية
// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Consumer<SettingsProvider>(
//         builder: (context, settings, child) {
//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: [
//               SettingItemWidget(
//                 title: 'المزامنة التلقائية',
//                 subtitle: 'مزامنة البيانات مع التخزين السحابي تلقائيًا.',
//                 icon: Icons.sync,
//                 trailing: Switch(
//                   value: settings.isAutoSyncEnabled,
//                   onChanged: settings.toggleAutoSync,
//                   activeColor: Colors.green,
//                 ),
//               ),
//               SettingItemWidget(
//                 title: 'الوضع المظلم',
//                 subtitle: 'تغيير مظهر التطبيق بين الفاتح والداكن.',
//                 icon: Icons.dark_mode,
//                 trailing: Switch(
//                   value: settings.isDarkMode,
//                   onChanged: settings.toggleDarkMode,
//                   activeColor: Colors.purple,
//                 ),
//               ),
//               SettingItemWidget(
//                 title: 'إدارة المساحة التخزينية',
//                 subtitle: 'تحكم في حجم قاعدة البيانات المحلية.',
//                 icon: Icons.storage,
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('ميزة قيد التطوير...'),
//                       action: SnackBarAction(
//                         label: 'إغلاق',
//                         onPressed: () {},
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// // 🔹 ويدجت مخصصة لعناصر الإعدادات
// class SettingItemWidget extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Widget? trailing;
//   final VoidCallback? onTap;

//   const SettingItemWidget({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     this.trailing,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 2,
//       child: ListTile(
//         leading: Icon(icon, color: Colors.blueAccent, size: 30),
//         title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         subtitle: Text(subtitle),
//         trailing: trailing,
//         onTap: onTap,
//       ),
//     );
//   }
// }

// // 🔹 تشغيل التطبيق مع المزود
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => SettingsProvider(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: ThemeMode.system,
//         home: SettingsScreen(),
//       ),
//     ),
//   );
// }





import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAutoSyncEnabled = false;
  bool _isDarkMode = false;
  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initNotifications();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAutoSyncEnabled = prefs.getBool('autoSync') ?? false;
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _initNotifications() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'مزامنة البيانات',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }

  Future<void> _toggleAutoSync(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSync', newValue);
    setState(() {
      _isAutoSyncEnabled = newValue;
    });

    _showNotification(
      newValue ? '🔄 المزامنة التلقائية' : '📴 إيقاف المزامنة',
      newValue ? 'تم تفعيل المزامنة التلقائية للبيانات.' : 'تم إيقاف المزامنة التلقائية.',
    );
  }

  Future<void> _toggleDarkMode(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', newValue);
    setState(() {
      _isDarkMode = newValue;      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSettingItem(
            title: 'المزامنة التلقائية',
            subtitle: 'مزامنة البيانات مع التخزين السحابي تلقائيًا.',
            icon: Icons.sync,
            trailing: Switch(
              value: _isAutoSyncEnabled,
              onChanged: _toggleAutoSync,
              activeColor: Colors.green,
            ),
          ),
          _buildSettingItem(
            title: 'الوضع المظلم',
            subtitle: 'تغيير مظهر التطبيق بين الفاتح والداكن.',
            icon: Icons.dark_mode,
            trailing: Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              activeColor: Colors.purple,
            ),
          ),
          _buildSettingItem(
            title: 'إدارة المساحة التخزينية',
            subtitle: 'تحكم في حجم قاعدة البيانات المحلية.',
            icon: Icons.storage,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ميزة قيد التطوير...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}


// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // class SettingsScreen extends StatefulWidget {
// //   @override
// //   _SettingsScreenState createState() => _SettingsScreenState();
// // }

// // class _SettingsScreenState extends State<SettingsScreen> {
// //   bool _isAutoSyncEnabled = false;
// //   late FlutterLocalNotificationsPlugin _notificationsPlugin;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadSettings();
// //     _initNotifications(); // تهيئة الإشعارات
// //   }

// //   // 🟢 تحميل الإعدادات المحفوظة
// //   Future<void> _loadSettings() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _isAutoSyncEnabled = prefs.getBool('autoSync') ?? false;
// //     });
// //   }

// //   // 🔵 تهيئة الإشعارات
// //   Future<void> _initNotifications() async {
// //     _notificationsPlugin = FlutterLocalNotificationsPlugin();
// //     const AndroidInitializationSettings androidSettings =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');

// //     final InitializationSettings settings =
// //         InitializationSettings(android: androidSettings);

// //     await _notificationsPlugin.initialize(settings);
// //   }

// //   // 🔥 دالة إرسال إشعار
// //   Future<void> _showNotification(String title, String body) async {
// //     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
// //       'sync_channel',
// //       'مزامنة البيانات',
// //       importance: Importance.high,
// //       priority: Priority.high,
// //     );

// //     const NotificationDetails details = NotificationDetails(android: androidDetails);
// //     await _notificationsPlugin.show(0, title, body, details);
// //   }

// //   // 🔄 تحديث حالة المزامنة التلقائية
// //   Future<void> _toggleAutoSync(bool newValue) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('autoSync', newValue);
// //     setState(() {
// //       _isAutoSyncEnabled = newValue;
// //     });

// //     if (newValue) {
// //       _showNotification('🔄 المزامنة التلقائية', 'تم تفعيل المزامنة التلقائية للبيانات.');
// //     } else {
// //       _showNotification('📴 إيقاف المزامنة', 'تم إيقاف المزامنة التلقائية.');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             ListTile(
// //               title: Text('المزامنة التلقائية', style: TextStyle(fontSize: 18)),
// //               subtitle: Text('مزامنة البيانات مع التخزين السحابي تلقائيًا.'),
// //               trailing: Switch(
// //                 value: _isAutoSyncEnabled,
// //                 onChanged: _toggleAutoSync,
// //                 activeColor: Colors.green,
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             Divider(),
// //             SizedBox(height: 10),
// //             ListTile(
// //               title: Text('إدارة المساحة التخزينية', style: TextStyle(fontSize: 18)),
// //               subtitle: Text('تحكم في حجم قاعدة البيانات المحلية.'),
// //               trailing: Icon(Icons.storage, color: Colors.blueAccent),
// //               onTap: () {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   SnackBar(content: Text('ميزة قيد التطوير...'))
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
