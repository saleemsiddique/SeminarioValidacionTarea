import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seminariovalidacion/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier{
  final String _baseUrl = 'flutter-varios-6b687-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  late Product selectedProduct;

  ProductsService(){
    print("entra");
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    //Estamos cargando
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, '/products.json');
    print(url);
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = jsonDecode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    },);
    print(this.products[1].picture);

    //Ya no estamos cargando
    this.isLoading = false;
    notifyListeners();

    return this.products;
  }
}