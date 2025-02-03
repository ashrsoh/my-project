class Product {
  final String id;
  final String name;
  final String price;
  final String quantity;
  final String date;
  final String userId;
  final String totalPrice;
  final String note;
  final String note1;
  final String note2;
  final String note3;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.date,
    required this.userId,
    required this.totalPrice,
    required this.note,
    required this.note1,
    required this.note2,
    required this.note3,
  });

  // دالة لتحويل خريطة إلى كائن Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      quantity: map['quantity'] ?? '',
      date: map['date'] ?? '',
      userId: map['userId'] ?? '',
      totalPrice: map['totalPrice'] ?? '',
      note: map['note'] ?? '',
      note1: map['note1'] ?? '',
      note2: map['note2'] ?? '',
      note3: map['note3'] ?? '',
    );
  }

  // دالة لتحويل الكائن إلى Map
  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'date': date,
      'userId': userId,
      'totalPrice': totalPrice,
      'note': note,
      'note1': note1,
      'note2': note2,
      'note3': note3,
    };
  }
}
