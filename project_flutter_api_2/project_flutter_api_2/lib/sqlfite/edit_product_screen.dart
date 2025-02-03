import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/sqlfite/sqlflite.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function onUpdate;

  EditProductScreen({required this.product, required this.onUpdate});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, description, category, sellerName;
  late double price, rating;
  late int stockQuantity;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    name = widget.product['name'];
    price = widget.product['price'];
    imageUrl = widget.product['imageUrl'];
    description = widget.product['description'];
    stockQuantity = widget.product['stockQuantity'];
    category = widget.product['category'];
    rating = widget.product['rating'] ?? 0.0;
    sellerName = widget.product['sellerName'];
  }

  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseHelper.instance.updateProduct(widget.product['id'], {
        'name': name,
        'price': price,
        'imageUrl': imageUrl ?? '',
        'description': description,
        'stockQuantity': stockQuantity,
        'category': category,
        'rating': rating,
        'sellerName': sellerName,
        'addedDate': widget.product['addedDate'],
      });

      widget.onUpdate();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل المنتج', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('اسم المنتج', name, Icons.shopping_cart, (value) => name = value!),
              buildTextField('السعر', price.toString(), Icons.attach_money, (value) => price = double.parse(value!),
                  isNumber: true),
              buildTextField('الوصف', description, Icons.description, (value) => description = value!),
              buildTextField('رابط الصورة', imageUrl ?? '', Icons.image, (value) => imageUrl = value),
              buildTextField('الكمية في المخزون', stockQuantity.toString(), Icons.store, (value) => stockQuantity = int.parse(value!),
                  isNumber: true),
              buildTextField('الفئة', category, Icons.category, (value) => category = value!),
              buildTextField('التقييم', rating.toString(), Icons.star, (value) => rating = double.parse(value!),
                  isNumber: true),
              buildTextField('اسم البائع', sellerName, Icons.person, (value) => sellerName = value!),

              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: updateProduct,
                icon: Icon(Icons.update, size: 28, color: Colors.white),
                label: Text('تحديث المنتج', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 8,
                  shadowColor: Colors.green.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String initialValue, IconData icon, Function(String?) onSave, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onSaved: onSave,
      ),
    );
  }
}
