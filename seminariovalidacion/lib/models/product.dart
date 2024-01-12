import 'dart:convert';

class Product {
  String? id;
  bool available;
  String name;
  String? fecha;
  String? picture;
  double price;

  Product({
    this.id,
    required this.available,
    required this.name,
    this.fecha,
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
        fecha: json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : name,
        "available": available,
        "name": name,
        "fecha": fecha,
        "picture": picture ?? null,
        "price": price,
      };

  Product copy() => Product(
      available: this.available,
      picture: this.picture,
      name: this.name,
      price: this.price,
      id: this.id,
      fecha: this.fecha);
}
