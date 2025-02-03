import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter_api_2/screen/edit_product_screen.dart';

class InsertProduct extends StatefulWidget {
  final String userId;

  const InsertProduct({Key? key, required this.userId}) : super(key: key);

  @override
  State<InsertProduct> createState() => _InsertProductState();
}

class _InsertProductState extends State<InsertProduct> {
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  TextEditingController note1 = TextEditingController();
  TextEditingController note2 = TextEditingController();
  TextEditingController note3 = TextEditingController();
  

  List<Map<String, dynamic>> products = [];
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      String url = "http://192.168.8.41/projectapi_flutter_php/api_php/product/getproducts.php?userId=$userId";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["status"] == "done") {
          setState(() {
            products = List<Map<String, dynamic>>.from(result["data"] ?? []);
          });
        } else {
          print("Error fetching products: ${result["message"]}");
        }
      } else {
        print("Failed to fetch products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
Future<void> insertProduct() async {
  if (name.text.isEmpty ||
      quantity.text.isEmpty ||
      price.text.isEmpty ||
      date.text.isEmpty ||
      totalPrice.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All fields are required")),
    );
    return;
  }

  try {
    String url = "http://192.168.8.41/projectapi_flutter_php/api_php/product/addproduct.php";
    var response = await http.post(
      Uri.parse(url),
      body: {
        "action": "add",
        "name": name.text,
        "quantity": quantity.text,
        "price": price.text,
        "date": date.text,
        "userId": userId,
        "total_price": totalPrice.text,
        "note": "",
        "note1": note1.text,
        "note2": note2.text,
        "note3": note3.text,
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result["status"] == "done") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully")),
        );
        fetchProducts();
        clearFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${result["message"]}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add product: ${response.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

void clearFields() {
  setState(() {
    name.clear();
    quantity.clear();
    price.clear();
    date.clear();
    totalPrice.clear();
    note1.clear();
    note2.clear();
    note3.clear();
  });
}
  Future<void> deleteProduct(String productId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        String url = "http://192.168.8.41/projectapi_flutter_php/api_php/product/deleteproduct.php";
        var response = await http.post(Uri.parse(url), body: {
          "id": productId,
        });

        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          if (result["status"] == "done") {
            fetchProducts();
            print("Product deleted successfully");
          } else {
            print("Error: ${result["message"]}");
          }
        } else {
          print("Failed to delete product: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),

        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(name, "Name", Icons.edit),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(quantity, "Quantity", Icons.format_list_numbered),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(price, "Price", Icons.attach_money),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(date, 
                    "Date", Icons.calendar_today, ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(totalPrice, "Total Price", Icons.calculate),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(note1, "Note 1", Icons.note),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(note2, "Note 2", Icons.note_alt),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(note3, "Note 3", Icons.note_add),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
      onPressed: insertProduct,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
                  backgroundColor: Colors.green, // لون الزر
                ),
                icon: const Icon(Icons.save, size: 25, color: Colors.white), // أيقونة الحفظ
                label: const Text(
                  'Save',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: fetchProducts,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blue, // لون الزر
                ),
                icon: const Icon(Icons.refresh, size: 25, color: Colors.white), // أيقونة التحديث
                label: const Text(
                  'Refresh',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Products List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Quantity")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Total Price")),
                    DataColumn(label: Text("Note 1")),
                    DataColumn(label: Text("Note 2")),
                    DataColumn(label: Text("Note 3")),
                    DataColumn(label: Text("Update")),
                    DataColumn(label: Text("Delete")),
                  ],
                  rows: products.map((product) {
                    return DataRow(cells: [
                      DataCell(Text(product['id'].toString())),
                      DataCell(Text(product['name'] ?? '')),
                      DataCell(Text(product['quantity'] ?? '')),
                      DataCell(Text(product['price'] ?? '')),
                      DataCell(Text(product['date'] ?? '')),
                      DataCell(Text(product['total_price'] ?? '')),
                      DataCell(Text(product['note1'] ?? '')),
                      DataCell(Text(product['note2'] ?? '')),
                      DataCell(Text(product['note3'] ?? '')),
                      DataCell(
                     IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () {
    // عند الضغط على زر التعديل يتم نقل المستخدم إلى شاشة UpdateProduct مع تمرير البيانات الخاصة بالمنتج
   Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EditProductScreen(product: product, onUpdate: null,
    ),
  ),
);

  },
),
),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteProduct(product['id'].toString());
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
