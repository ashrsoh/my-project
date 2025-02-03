import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApi {
  final String url = "http://192.168.8.41/projectapi_flutter_php/api_php/product"; // تأكد من أن هذا الرابط صحيح

  // دالة لإضافة المنتج
  Future<void> insertProduct(Map<String, String> productData) async {
    try {
      var response = await http.post(Uri.parse("$url/addproduct.php"), body: productData);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["status"] == "done") {
          print("Product added successfully");
        } else {
          print("Error: ${result["message"]}");
        }
      } else {
        print("Failed to add product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // دالة لتحديث المنتج
  Future<void> updateProduct(Map<String, String> productData) async {
    try {
      var response = await http.post(Uri.parse("$url/updateproduct.php"), body: productData);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["status"] == "done") {
          print("Product updated successfully");
        } else {
          print("Error: ${result["message"]}");
        }
      } else {
        print("Failed to update product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // دالة لحذف المنتج
  Future<void> deleteProduct(String productId) async {
    try {
      var response = await http.post(Uri.parse("$url/deleteproduct.php"), body: {
        "id": productId,
      });

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["status"] == "done") {
          print("Product deleted successfully");
        } else {
          print("Error: ${result["message"]}");
        }
      } else {
        print("Failed to delete product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // دالة لجلب المنتجات
  Future<List<Map<String, dynamic>>> fetchUserProducts(String userId) async {
    try {
      var response = await http.get(Uri.parse("$url/getproducts.php?userId=$userId"));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["status"] == "done") {
          return List<Map<String, dynamic>>.from(result["data"]);
        } else {
          throw Exception("Failed to fetch products: ${result["message"]}");
        }
      } else {
        throw Exception("Failed to fetch products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error: $e");
    }
  }
}
