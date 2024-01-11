import 'package:flutter/material.dart';
import 'package:seminariovalidacion/models/product.dart';

class ProductFormProvider extends ChangeNotifier{
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  updateAvailability(bool result){
    this.product.available = result;
    notifyListeners();
  }
}
