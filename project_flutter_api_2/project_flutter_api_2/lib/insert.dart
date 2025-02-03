import 'dart:convert'; // Add this import
import 'package:project_flutter_api_2/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController note = TextEditingController(); // Added note controller
  UserApi userapi = UserApi();

  Future<void> insertdata() async {
    if (name.text != "" && email.text != "" && password.text != "" && note.text != "") {
      try {
        String url = "http://192.168.8.41/projectapi_flutter_php/api_php/adddata.php"; // Updated IP address
        var res = await http.post(Uri.parse(url), body: {
          "name": name.text,
          "email": email.text,
          "password": password.text,
          "note": note.text // Added note field
        });

        if (res.statusCode == 200) {
          var response = jsonDecode(res.body);
          if (response["status"] == "done") {
            print("Data inserted successfully");
            Navigator.pop(context, true);
          } else {
            print("Failed to insert data: ${response["message"]}");
          }
        } else {
          print("Failed to insert data: ${res.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("Missing required fields");
    }
  }

  @override
  void initState() {
    super.initState();
    // Remove the call to insertdata here
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Insert User'),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              child: TextField(
                controller: name,
                decoration:
                    const InputDecoration(label: Text('Enter the name')),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: TextField(
                controller: email,
                decoration:
                    const InputDecoration(label: Text('Enter the email')),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: TextField(
                controller: password,
                decoration:
                    const InputDecoration(label: Text('Enter the password')),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: TextField(
                controller: note,
                decoration:
                    const InputDecoration(label: Text('Enter the note')), // Added note field
              ),
            ),
            Container(
                margin: const EdgeInsets.all(12),
                child: ElevatedButton(
                    onPressed: () {
                      insertdata();
                      userapi.getAllUsers();
                      Navigator.pop(context, true);
                    },
                    child: const Text('Save')))
          ],
        ),
      ),
    );
  }
}
