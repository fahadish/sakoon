import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/productModel/product_model.dart';
import '../../provider/product_provider/product_provider.dart';

class CategoryProductsScreen extends StatelessWidget {
  final int categoryId;

  CategoryProductsScreen({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final List<ProductC> products = productProvider.products
        .where((product) => product.categoryId == categoryId)
        .toList();

    return products.isEmpty
        ? Center(
      child: Text('No products available for this category'),
    )
        : ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final ProductC product = products[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Dismissible(
            key: Key(product.id.toString()), // Unique key for each item
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              // Remove the item from the database and the list
              productProvider.deleteProduct(product.id);
            },
            child: ListTile(
              // leading: Container(
              //   width: 80,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     image: product.imagePath.isNotEmpty
              //         ? DecorationImage(
              //       image: AssetImage(product.imagePath),
              //       fit: BoxFit.cover,
              //     )
              //         : null,
              //   ),
              // ),

              leading: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: product.imagePath.isNotEmpty
                      ? DecorationImage(
                    image: FileImage(File(product.imagePath)), // Load from file path
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),

              title: Text(
                product.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Sale Price: ${product.salePrice.toString()}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Purchase Price: ${product.purchasePrice.toString()}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Quantity: ${product.quantity.toString()}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              onTap: () {
                // Handle tapping on a product if needed
              },
            ),
          ),
        );
      },
    );
  }
}
