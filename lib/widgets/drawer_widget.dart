import 'package:flutter/material.dart';
import 'package:price_tracker_app/screens/home_screen.dart';
import 'package:price_tracker_app/screens/add_item_screen.dart';
import 'package:price_tracker_app/screens/setting_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.track_changes, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Price Tracker',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'الرئيسية',
            screen: HomeScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.add,
            text: 'إضافة عنصر',
            screen: AddItemScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: 'الإعدادات',
            screen: SettingsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required Widget screen}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // إغلاق الـ Drawer
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}
