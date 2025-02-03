class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String note;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.note,
  });

  factory User.fromMap(Map map) {
    return User(
      id: map['id']?.toString() ?? '0',
      name: map['name'] ?? 'Unknown',
      email: map['email'] ?? 'No email',
      password: map['password'] ?? '',
      note: map['note'] ?? '',
    );
  }
}






























