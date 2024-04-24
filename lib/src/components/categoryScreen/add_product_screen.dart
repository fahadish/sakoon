import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/category_provider/category_provider.dart';
import '../../provider/product_provider/product_provider.dart';
import '../../widget/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  final int categoryId;

  AddProductScreen({required this.categoryId});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _purchasePriceController =
  TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerWidget(
                onImageSelected: (image) {
                  setState(() {
                    _image = image;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _salePriceController,
                decoration: InputDecoration(
                  labelText: 'Sale Price (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _purchasePriceController,
                decoration: InputDecoration(
                  labelText: 'Purchase Price (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _addProduct();
                  },
                  child: Text('Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() {
    final productName = _nameController.text;
    final salePrice = double.tryParse(_salePriceController.text) ?? 0.0;
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    if (productName.isNotEmpty &&
        salePrice > 0 &&
        purchasePrice > 0 &&
        quantity > 0 &&
        _image != null) {
      Provider.of<ProductProvider>(context, listen: false).addProduct(
        categoryId: widget.categoryId,
        name: productName,
        salePrice: salePrice,
        purchasePrice: purchasePrice,
        quantity: quantity,
        imagePath: _image!.path,
      );
      Navigator.pop(context);
    } else {
      // Show error message or handle empty fields
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all fields and select an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
