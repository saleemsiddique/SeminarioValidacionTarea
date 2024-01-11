import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/models/product.dart';
import 'package:seminariovalidacion/providers/product_form_provider.dart';
import 'package:seminariovalidacion/services/products_service.dart';
import 'package:seminariovalidacion/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              ProductImage(url: productService.selectedProduct.picture),
              Positioned(
                top: 60,
                right: 20,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 20,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          _ProductForm(
            product: productService.selectedProduct,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _ProductForm extends StatelessWidget {
  final Product product;
  const _ProductForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
      final productForm = Provider.of<ProductFormProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _ProductFormDecoration(),
        child: Form(
            child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              initialValue: product.name,
              onChanged: (value) => product.name = value,
              validator: (value) {
                if (value == null || value.length < 1) {
                  return 'El nombre es obligatorio';
                }
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre del producto',
                labelText: 'Nombre:',
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              initialValue: '${product.price}',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              onChanged: (value) {
                if (double.tryParse(value) == null) {
                  product.price = 0;
                } else {
                  product.price = double.parse(value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                hintText: '150€',
                labelText: 'Precio:',
              ),
            ),
            SizedBox(height: 30),
            SwitchListTile.adaptive(
              value: product.available,
              title: Text('Disponible'),
              activeColor: Colors.indigo,
              onChanged: (value) => productForm.updateAvailability,
            ),
          ],
        )),
      ),
    );
  }

  BoxDecoration _ProductFormDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ],
      );
}

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
