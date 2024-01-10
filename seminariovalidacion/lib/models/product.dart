import 'dart:convert';

class Product {
  String? id;
  bool available;
  String name;
  String? picture;
  double price;

  Product({
    this.id,
    required this.available,
    required this.name,
    this.picture,
    required this.price,
  });

  factory Product.fromRawJson(String str) => Product.fromMap(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] ?? "",
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Product copy() => Product(
      available: this.available,
      name: this.name,
      price: this.price,
      id: this.id
      );
}
