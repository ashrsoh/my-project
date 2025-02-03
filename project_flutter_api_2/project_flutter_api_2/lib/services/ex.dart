import 'dart:convert';

import 'package:project_flutter_api_2/models/product.dart';
import 'package:project_flutter_api_2/models/user.dart';
import 'package:http/http.dart' as http;

class api {
  String url = "http://192.168.8.41/projectapi_flutter_php/api_php/"; // Updated IP address

  Future<List<User>> getalldata() async {
    List<User> alldata = [];
    try {
      var res = await http.get(Uri.parse(url + "getdata.php"));
      if (res.statusCode == 200) {
        var data = res.body;
        var decode = jsonDecode(data) as List;
        for (var i in decode) {
          User user = User.fromMap(i);
          alldata.add(user);
        }
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return alldata;
  }
}



class ap {
   String url = "http://192.168.8.41/projectapi_flutter_php/api_php/product"; // Ensure this URL is correct

  Future<List<Product>> getalldata() async {
    List<Product> alldata = [];
    try {
      var res = await http.get(Uri.parse(url + "getproducts.php"));
      if (res.statusCode == 200) {
        var data = res.body;
        var decode = jsonDecode(data) as List;
        for (var i in decode) {
          Product product = Product.fromMap(i);
          alldata.add(product );
        }
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return alldata;
  }
}
