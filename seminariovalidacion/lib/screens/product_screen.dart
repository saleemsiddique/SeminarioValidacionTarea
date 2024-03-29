import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/models/product.dart';
import 'package:seminariovalidacion/providers/product_form_provider.dart';
import 'package:seminariovalidacion/services/products_service.dart';
import 'package:seminariovalidacion/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

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

class _ProductScreenBody extends StatefulWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  State<_ProductScreenBody> createState() => _ProductScreenBodyState();
}

class _ProductScreenBodyState extends State<_ProductScreenBody> {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              ProductImage(url: productForm.product.picture),
              Positioned(
                top: 60,
                right: 20,
                child: IconButton(
                  onPressed: () async {
                    String? urlImage = await _processImage();
                    widget.productService.updateSelectedProductImage(urlImage!);
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 80,
                child: IconButton(
                  onPressed: () async {
                    String? urlImage = await _processFromGalleryImage();
                    widget.productService.updateSelectedProductImage(urlImage!);
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.image,
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
            product: widget.productService.selectedProduct,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productForm.isValidForm()) return;
          final String? urlImage = await widget.productService.uploadImage();
          if (urlImage != null) {
            widget.productService.selectedProduct.picture = urlImage;
          }
          await widget.productService.saveOrCreateProduct(productForm.product);
          Navigator.pop(context);
        },
        child: widget.productService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Future<String?> _processImage() async {
    final _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile == null) {
      print('No Selecciono nada');
      return null;
    } else {
      print('Tenemos imagen ${pickedFile.path}');
      return pickedFile.path;
    }
  }
}

  Future<String?> _processFromGalleryImage() async {
    final _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile == null) {
      print('No Selecciono nada');
      return null;
    } else {
      print('Tenemos imagen ${pickedFile.path}');
      return pickedFile.path;
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
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
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
                TextFormField(
                  initialValue: product.fecha,
                  enabled: false,                
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Fecha de registro',
                    labelText: 'Fecha de registro:',
                  ),
                ),
                SizedBox(height: 30),
                SwitchListTile.adaptive(
                  value: product.available,
                  title: Text('Disponible'),
                  activeColor: Colors.indigo,
                  onChanged: productForm.updateAvailability,
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
