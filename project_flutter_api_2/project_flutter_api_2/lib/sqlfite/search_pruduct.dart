import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/sqlfite/sqlflite.dart';

class SearchProductPage extends StatefulWidget {
  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];

  // دالة البحث
  void _searchProduct() async {
    final name = _searchController.text;
    if (name.isNotEmpty) {
      var result = await DatabaseHelper.instance.searchProduct(name);
      setState(() {
        _products = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بحث عن منتج'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل البحث
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'أدخل اسم المنتج',
                labelStyle: TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.blueAccent),
                  onPressed: _searchProduct,
                ),
              ),
            ),
            SizedBox(height: 16),
            // عرض المنتجات بعد البحث في Column
            Expanded(
              child: _products.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _products.map((product) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة المنتج
                        product['imageUrl'] != null && product['imageUrl'].isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.file(
                            File(product['imageUrl']),
                            width: double.infinity,
                            height: 180,  // تحديد ارتفاع مناسب للصورة
                            fit: BoxFit.cover,
                          ),
                        )
                            : Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 70, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text("السعر: ${product['price']} ر.س", style: TextStyle(color: Colors.green)),
                              Text("المخزون: ${product['stockQuantity']}", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                }).toList(),
              )
                  : Center(child: Text('لا توجد نتائج')),
            ),
          ],
        ),
      ),
    );
  }
}