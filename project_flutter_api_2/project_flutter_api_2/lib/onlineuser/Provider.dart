import 'package:flutter/material.dart';
import '../services/user_api.dart'; // تأكد من استيراد UserApi
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchConnectedUsers() async {
    _isLoading = true;
    notifyListeners();

    UserApi userApi = UserApi();
    _users = await userApi.getAllUsers(); // تأكد من أن هذه الدالة تجلب المستخدمين المتصلين

    _isLoading = false;
    notifyListeners();
  }
}