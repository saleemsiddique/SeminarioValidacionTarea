import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seminariovalidacion/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-6b687-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = false;
  bool isSaving = false;
  late Product selectedProduct;
  File? newPictureFile;

  ProductsService() {
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

    productsMap.forEach(
      (key, value) {
        final tempProduct = Product.fromMap(value);
        tempProduct.id = key;
        this.products.add(tempProduct);
      },
    );
    print(this.products[1].picture);

    //Ya no estamos cargando
    this.isLoading = false;
    notifyListeners();

    return this.products;
  }

  Future<String> updateProduct(Product product) async {
    print('Editando');
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toRawJson());
    final decodedData = resp.body;
    print('decoded Data: $decodedData');
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    print('Creando');
    print(product.toJson());
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toRawJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    this.products.add(product);
    return product.id!;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
      final index = products.indexWhere((element) => element.id == product.id);
      products[index] = product;
    }
    isSaving = false;
    notifyListeners();
  }

Future deleteProduct(Product product) async {
  print("Borrando");
  final url = Uri.https(_baseUrl, 'products/${product.id}.json'); // Use the product ID in the URL
  final resp = await http.delete(url);
  final decodedData = json.decode(resp.body);
  this.products.remove(product);
}


  Future<String?> uploadImage() async {
    if (newPictureFile == null) {
      return null;
    }
    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtfmi0oq1/image/upload?upload_preset=os2vrjtx');
    final imageUpLoadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUpLoadRequest.files.add(file);
    final streamResponse = await imageUpLoadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("Ha habido un error");
      print(resp.body);
      return null;
    }
    newPictureFile = null;
    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
