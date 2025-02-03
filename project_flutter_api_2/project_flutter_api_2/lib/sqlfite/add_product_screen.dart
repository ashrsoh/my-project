import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/sqlfite/sqlflite.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  final Function onAdd;

  AddProductScreen({required this.onAdd});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', description = '', category = '', sellerName = '';
  double price = 0.0, rating = 0.0;
  int stockQuantity = 1;
  String? imageUrl;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        imageUrl = result.files.single.path;
      });
    }
  }

  Future<void> addProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await DatabaseHelper.instance.insertProduct({
        'name': name,
        'price': price,
        'imageUrl': imageUrl ?? '',
        'description': description,
        'stockQuantity': stockQuantity,
        'category': category,
        'rating': rating,
        'sellerName': sellerName,
        'addedDate': DateTime.now().toString(),
      });

      widget.onAdd();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة منتج', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyanAccent[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3.5,
                  children: [
                    _buildTextField(
                      label: 'اسم المنتج',
                      icon: Icons.production_quantity_limits,
                      onChanged: (value) => name = value,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
                    ),
                    _buildTextField(
                      label: 'السعر',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value!) ?? 0.0,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال السعر' : null,
                    ),
                    _buildTextField(
                      label: 'الوصف',
                      icon: Icons.description,
                      onChanged: (value) => description = value,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال الوصف' : null,
                    ),
                    _buildTextField(
                      label: 'الفئة',
                      icon: Icons.category,
                      onChanged: (value) => category = value,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال الفئة' : null,
                    ),
                    _buildTextField(
                      label: 'التقييم',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => rating = double.tryParse(value!) ?? 0.0,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال التقييم' : null,
                    ),
                    _buildTextField(
                      label: 'اسم البائع',
                      icon: Icons.person,
                      onChanged: (value) => sellerName = value,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال اسم البائع' : null,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imageUrl!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Row(
                    children: [
                      Icon(Icons.image, color: Colors.cyanAccent[700]),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'اضغط لاختيار صورة المنتج',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _formKey.currentState!.save();
                        
                        if (price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('السعر يجب أن يكون أكبر من صفر'), backgroundColor: Colors.red)
                          );
                          return;
                        }

                        final result = await DatabaseHelper.instance.insertProduct({
                          'name': name,
                          'price': price,
                          'imageUrl': imageUrl ?? '',
                          'description': description,
                          'stockQuantity': stockQuantity,
                          'category': category,
                          'rating': rating,
                          'sellerName': sellerName,
                          'addedDate': DateTime.now().toString(),
                        });

                        if (result > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حفظ المنتج بنجاح!'), backgroundColor: Colors.green)
                          );
                          await widget.onAdd();
                          Navigator.pop(context);
                        } else {
                          throw Exception('فشل في حفظ المنتج');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red)
                        );
                        print('Error saving product: $e');
                      }
                    }
                  },
                  icon: Icon(Icons.save, size: 30, color: Colors.white), // أيقونة الحفظ
                  label: Text(
                    'حفـــــظ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700], // لون مميز
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // زوايا ناعمة
                    ),
                    elevation: 8, // ظل جميل
                    shadowColor: Colors.greenAccent.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurple),
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
