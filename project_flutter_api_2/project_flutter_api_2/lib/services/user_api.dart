import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserApi {
  final String url = "http://192.168.8.41/projectapi_flutter_php/api_php"; // Ensure this URL is correct

  Future<List<User>> getAllUsers() async {
    List<User> allUsers = [];
    try {
      print("Fetching users from: $url/getdata.php"); // Debug statement
      var response = await http.get(Uri.parse("$url/getdata.php"));
      print("Response status: ${response.statusCode}"); // Debug statement
      print("Response body: ${response.body}"); // Debug statement
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);

        // Check if the response contains a "data" key
        if (decode is Map && decode['data'] is List) {
          var datauser = decode['data'];

          for (var i in datauser) {
            User user = User.fromMap(i);
            allUsers.add(user);
          }
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e"); // Debug statement
      throw Exception("Error: $e");
    }
    return allUsers;
  }
Future<void> deleteUser(String id) async {
  final String url = "http://192.168.8.41/projectapi_flutter_php/api_php"; // Ensure this URL is correct
  // Ensure this URL is correct
  try {
    var response = await http.post(Uri.parse("$url/deletedata.php"), body: {
      "id": id,
    });
    if (response.statusCode != 200) {
      throw Exception("Failed to delete user: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e"); // Debug statement
    throw Exception("Error: $e");
  }
}



  Future<void> updateUser(User user) async {
    try {
      var response = await http.post(Uri.parse("$url/updatedata.php"), body: {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "password": user.password,
        "note": user.note,
      });
      if (response.statusCode != 200) {
        throw Exception("Failed to update user: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e"); // Debug statement
      throw Exception("Error: $e");
    }
  }
}
