import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_api.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _noteController; //  إضافة متغير للملاحظات

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _noteController = TextEditingController(text: widget.user.note); // ✅ تعبئة الملاحظات
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _noteController.dispose(); // ✅ التخلص من المتحكم عند الانتهاء
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.user.id,
        name: _nameController.text,
        email: _emailController.text,
        password: widget.user.password, // لا يتم تعديله هنا
        note: _noteController.text, // ✅ تمرير الملاحظات
      );

      await UserApi().updateUser(updatedUser);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'), // ✅ إضافة حقل الملاحظات
                validator: (value) => value!.isEmpty ? 'Enter a note' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
