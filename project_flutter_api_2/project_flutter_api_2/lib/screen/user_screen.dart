import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/insert.dart';
import 'package:project_flutter_api_2/insert_product.dart';
import 'package:project_flutter_api_2/services/user_api.dart';
import '../models/user.dart';
import 'edit_user_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<User>> _futureUsers;
  Color _evenColor = Colors.teal;
  Color _oddColor = Colors.orange;
  String _searchQuery = "";
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _futureUsers = UserApi().getAllUsers();
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _futureUsers = UserApi().getAllUsers();
    });
  }

  void _filterUsers(String query, List<User> users) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = users
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  Future<void> _deleteUser(String id) async {
    await UserApi().deleteUser(id);
    await _refreshUsers();
  }

  Future<void> _editUser(User user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: user),
      ),
    );
    if (result == true) {
      await _refreshUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers,
            tooltip: 'Refresh Users',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
              ),
              onChanged: (query) async {
                final users = await _futureUsers;
                _filterUsers(query, users);
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Center(
                child: Text(
                  'Customize Colors',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('اختيار اللون الازرق '),
              onTap: () {
                setState(() {
                  _evenColor = Colors.blue;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('تبديل الى اللون الاحمر'),
              onTap: () {
                setState(() {
                  _oddColor = Colors.red;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final users = _searchQuery.isEmpty
                ? snapshot.data!
                : _filteredUsers;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size.width > 600 ? 3 : 2, // عرض 2-3 كروت حسب الحجم
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: size.width > 400 ? 1.3 : 1,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _userCard(
                      user,
                      index.isEven ? _evenColor : _oddColor,
                      context);
                },
              ),
            );
          }
          return const Center(child: Text("No users found"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Insert()));
          if (result == true) {
            await _refreshUsers();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _userCard(User user, Color color, BuildContext context) {
    return Card(
      elevation: 8,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertProduct(userId: user.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.teal, size: 40),
                ),
                const SizedBox(height: 15),
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 24, color: Color.fromARGB(255, 243, 241, 246)),
                      onPressed: () => _editUser(user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 24, color: Color.fromARGB(255, 245, 18, 18)),
                      onPressed: () => _deleteUser(user.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}