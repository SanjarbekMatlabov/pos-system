class Product {
  final String id;
  final String name;
  final String? barcode;
  final int? categoryId;
  final double price;
  final double costPrice;
  final double quantity;

  Product({
    required this.id,
    required this.name,
    this.barcode,
    this.categoryId,
    required this.price,
    required this.costPrice,
    required this.quantity,
  });

  // Bazadan kelgan Map'ni Product obyektiga o'girish
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      categoryId: map['category_id'],
      price: map['price'],
      costPrice: map['cost_price'],
      quantity: map['quantity'],
    );
  }

  // Product obyektini bazaga yozish uchun Map'ga o'girish
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'category_id': categoryId,
      'price': price,
      'cost_price': costPrice,
      'quantity': quantity,
    };
  }
}