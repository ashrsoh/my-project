import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isArabic = true;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.8.41/projectapi_flutter_php/api_php/register.php'),
      body: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      },
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['status'] == 'success') {
      _showSuccessDialog(responseData['message']);
    } else {
      _showErrorDialog(responseData['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_isArabic ? 'نجاح' : 'Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(_isArabic ? 'تسجيل الدخول' : 'Login'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_isArabic ? 'خطأ' : 'Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(_isArabic ? 'حسناً' : 'OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.pink.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _isArabic ? 'إنشاء حساب' : 'Register',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                     const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'الاسم' : 'Name',
                          prefixIcon:const Icon(Icons.person),
                          border:const OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? (_isArabic ? 'يرجى إدخال الاسم' : 'Please enter your name') : null,
                      ),
                     const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'البريد الإلكتروني' : 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? (_isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter your email') : null,
                      ),
                     const  SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'كلمة المرور' : 'Password',
                          prefixIcon:const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) => value!.length < 6 ? (_isArabic ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : 'Password must be at least 6 characters') : null,
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _registerUser,
                              child: Text(_isArabic ? 'تسجيل' : 'Register', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isArabic = !_isArabic;
                          });
                        },
                        child: Text(_isArabic ? 'Switch to English' : 'التبديل إلى العربية'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(_isArabic ? 'لديك حساب؟ تسجيل الدخول' : 'Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}