import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  // مع الحفاظ على نفس بنية المعاملات الأصلية دون تغيير منطق الكود
  const EditProductScreen({Key? key, required this.product, required onUpdate}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _totalPriceController;
  late TextEditingController _noteController;
  late TextEditingController _note1Controller;
  late TextEditingController _note2Controller;
  late TextEditingController _note3Controller;
  late TextEditingController _userIdController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController       = TextEditingController(text: widget.product['name']);
    _quantityController   = TextEditingController(text: widget.product['quantity']);
    _priceController      = TextEditingController(text: widget.product['price']);
    _totalPriceController = TextEditingController(text: widget.product['total_price']);
    _noteController       = TextEditingController(text: widget.product['note']);
    _note1Controller      = TextEditingController(text: widget.product['note1']);
    _note2Controller      = TextEditingController(text: widget.product['note2']);
    _note3Controller      = TextEditingController(text: widget.product['note3']);
    _userIdController     = TextEditingController(text: widget.product['userId']);
    _dateController       = TextEditingController(text: widget.product['date']);
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> productData = {
        'id'         : widget.product['id'].toString(),
        'name'       : _nameController.text,
        'quantity'   : _quantityController.text,
        'price'      : _priceController.text,
        'total_price': _totalPriceController.text,
        'note'       : _noteController.text,
        'note1'      : _note1Controller.text,
        'note2'      : _note2Controller.text,
        'note3'      : _note3Controller.text,
        'userId'     : _userIdController.text,
        'date'       : _dateController.text,
      };

      var response = await http.post(
        Uri.parse("http://192.168.8.41/projectapi_flutter_php/api_php/product/updateproduct.php"),
        body: productData,
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["status"] == "done") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product updated successfully")),
          );
          Navigator.pop(context, true); // إرجاع true لتحديث القائمة في الشاشة السابقة
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${result["message"]}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update product: ${response.statusCode}")),
        );
      }
    }
  }

  // دالة مساعدة لبناء حقول الإدخال بتنسيق جميل
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = true,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: isRequired
          ? (value) => value == null || value.isEmpty ? "$label is required" : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        backgroundColor: Colors.deepPurple,
      ),
      // خلفية بتدرج ألوان خفيفة
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(controller: _nameController, label: "Name"),
                const SizedBox(height: 12),
                _buildTextField(controller: _quantityController, label: "Quantity"),
                const SizedBox(height: 12),
                _buildTextField(controller: _priceController, label: "Price"),
                const SizedBox(height: 12),
                _buildTextField(controller: _totalPriceController, label: "Total Price"),
                const SizedBox(height: 12),
                _buildTextField(controller: _noteController, label: "Note"),
                const SizedBox(height: 12),
                _buildTextField(controller: _note1Controller, label: "Note 1", isRequired: false),
                const SizedBox(height: 12),
                _buildTextField(controller: _note2Controller, label: "Note 2", isRequired: false),
                const SizedBox(height: 12),
                _buildTextField(controller: _note3Controller, label: "Note 3", isRequired: false),
                const SizedBox(height: 12),
                _buildTextField(controller: _userIdController, label: "User ID"),
                const SizedBox(height: 12),
                // حقل التاريخ مع أيقونة التقويم والقدرة على اختيار التاريخ
                _buildTextField(
                  controller: _dateController,
                  label: "Date",
                  readOnly: true,
                  onTap: () async {
                    // التحقق من أن قيمة التاريخ قابلة للتحويل، وإن لم تكن نستخدم تاريخ اليوم
                    DateTime initialDate;
                    try {
                      initialDate = DateTime.parse(_dateController.text);
                    } catch (e) {
                      initialDate = DateTime.now();
                    }

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _dateController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 17, 241, 28),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
