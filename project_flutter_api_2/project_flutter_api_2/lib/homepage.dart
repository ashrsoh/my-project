
import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/insert_product.dart';
import 'package:project_flutter_api_2/register_page.dart';
import 'package:project_flutter_api_2/screen/allprusucts_api.dart';
import 'package:project_flutter_api_2/screen/user_screen.dart';
import 'package:project_flutter_api_2/setting_app/setting_app.dart';
import 'package:project_flutter_api_2/sqlfite/product_screen.dart';
import 'package:project_flutter_api_2/sqlfite/search_pruduct.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _backgroundColor1 = Color.fromARGB(255, 85, 32, 198);
  Color _backgroundColor2 = Color.fromARGB(255, 200, 120, 255);

  void _changeTheme(Color color1, Color color2) {
    setState(() {
      _backgroundColor1 = color1;
      _backgroundColor2 = color2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 120, 50, 180),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text('اختر لون الخلفية',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              title: Text('أزرق غامق'),
              onTap: () => _changeTheme(Colors.indigo.shade900, Colors.blueAccent.shade400),
            ),
            ListTile(
              title: Text('أخضر'),
              onTap: () => _changeTheme(Colors.teal.shade900, Colors.lightGreenAccent.shade400),
            ),
            ListTile(
              title: Text('أحمر'),
              onTap: () => _changeTheme(Colors.red.shade900, Colors.redAccent.shade400),
            ),
            ListTile(
              title: Text('برتقالي'),
              onTap: () => _changeTheme(Colors.deepOrange.shade900, Colors.orangeAccent.shade400),
            ),
            ListTile(
              title: Text('بنفسجي'),
              onTap: () => _changeTheme(Colors.deepPurple.shade900, Colors.purpleAccent.shade400),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_backgroundColor1, _backgroundColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildCard(
                  _menuItems[index]['title'],
                  _menuItems[index]['imagePath'],
                  _menuItems[index]['color'],
                  context,
                  _menuItems[index]['page'],
                );
              },
            ),
          );
        },
      ),
    );
  }

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'العملاء', 'imagePath': 'assets/1738180083508.png', 'color': Colors.blueAccent, 'page': UserScreen()},
    {'title': 'الكميات المستهلكة', 'imagePath': 'assets/1738180083543.jpg', 'color': Colors.greenAccent, 'page': ProductListScreen()},
    {'title': 'المخزون', 'imagePath': 'assets/1738180083525.jpg', 'color': Colors.indigoAccent, 'page': ProductScreen()},
    {'title': 'تسجيل الخروج', 'imagePath': 'assets/1738248793050.png', 'color': Colors.redAccent, 'page': RegisterPage()},
    {'title': 'الإعدادات', 'imagePath': 'assets/1738180083517.png', 'color': Colors.deepPurpleAccent, 'page': SettingsPage()},
    {'title': 'استعلام عن منتج ', 'imagePath': 'assets/klipartz.com.png', 'color': Colors.deepPurpleAccent, 'page': SearchProductPage()},
  ];

  Widget _buildCard(String title, String imagePath, Color color, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
