import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/services/product_api.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key); // Added `key` parameter

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  late Future<List<Map<String, dynamic>>> _futureProducts;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _futureProducts = ProductApi().fetchUserProducts(""); // Fetch all products
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _fetchData();
    });
  }

  Future<void> _deleteProduct(String productId) async {
    await ProductApi().deleteProduct(productId);
    await _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
            tooltip: 'Refresh Products',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Price or User Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final filteredProducts = snapshot.data!.where((product) {
                      final userName = product['user_name']?.toLowerCase() ?? "";
                      final price = product['price']?.toString() ?? "";
                      return userName.contains(_searchQuery) || price.contains(_searchQuery);
                    }).toList();

                    return DataTable(
                      columns: const [
                        DataColumn(label: Text('Product Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('User Name')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: List<DataRow>.generate(
                        filteredProducts.length,
                        (index) {
                          final product = filteredProducts[index];
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              return index.isEven
                                  ? Colors.lightBlue.shade50
                                  : Colors.white;
                            }),
                            cells: [
                              DataCell(Text(product['name'] ?? '')),
                              DataCell(Text(product['price']?.toString() ?? '')),
                              DataCell(Text(product['user_name'] ?? '')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.green),
                                    onPressed: () {
                                      // TODO: Navigate to edit product screen
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteProduct(product['id']),
                                  ),
                                ],
                              )),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text("No products found"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
