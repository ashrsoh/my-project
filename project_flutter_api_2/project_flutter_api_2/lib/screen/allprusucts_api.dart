import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      String url = "http://192.168.8.41/projectapi_flutter_php/api_php/product/allpruduct.php";
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

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Quantity")),
          DataColumn(label: Text("Price")),
          DataColumn(label: Text("Date")),
          DataColumn(label: Text("Total Price")),
        ],
        rows: products.map((product) {
          bool isEven = products.indexOf(product) % 2 == 0;
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return isEven ? Colors.white : Colors.green[50];
            }),
            cells: [
              DataCell(Text(product['id'].toString())),
              DataCell(Text(product['name'] ?? '')),
              DataCell(Text(product['quantity'] ?? '')),
              DataCell(Text(product['price'] ?? '')),
              DataCell(Text(product['date'] ?? '')),
              DataCell(Text(product['total_price'] ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "Products List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: _buildDataTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
