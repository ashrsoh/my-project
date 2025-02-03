import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_flutter_api_2/sqlfite/sqlflite.dart';
import 'edit_product_screen.dart';
import 'add_product_screen.dart';

class ProductController extends GetxController {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  var products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await dbHelper.getProducts();
    products.assignAll(data);
  }

  Future<void> deleteProduct(int id) async {
    bool? confirm = await Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من أنك تريد حذف هذا المنتج؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );
    if (confirm == true) {
      await dbHelper.deleteProduct(id);
      loadProducts();
    }
  }
}

class ProductScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة المنتجات')),
      body: Obx(() => GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: product['imageUrl'] != null && product['imageUrl'].isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.file(
                                File(product['imageUrl']),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: 70, color: Colors.grey),
                            ),
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
                          Text("السعر: ${product['price']}", style: TextStyle(color: Colors.green)),
                          Text("المخزون: ${product['stockQuantity']}", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Get.to(() => EditProductScreen(
                                product: product,
                                onUpdate: productController.loadProducts,
                              )),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => productController.deleteProduct(product['id']),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => AddProductScreen(onAdd: productController.loadProducts)),
      ),
    );
  }
}
