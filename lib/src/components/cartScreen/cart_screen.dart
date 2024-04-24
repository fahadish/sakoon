import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider/product_provider.dart';

class CartScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to order history screen
            },
            icon: Icon(Icons.history),
          )
        ],
        title: Text('Cart'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          final selectedProducts = productProvider.selectedProducts;
          final totalBill = productProvider.getTotalBill();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    productProvider.setCustomerName(value);
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedProducts.length,
                  itemBuilder: (context, index) {
                    final product = selectedProducts[index];
                    final quantity = productProvider.getSelectedQuantity(product.id);
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Text('\$${product.salePrice * quantity}'),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Bill:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                    ),
                    Text(
                      '\$$totalBill',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    productProvider.printBill(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(Icons.print, size: 24),
                  label: Text(
                    'Print Bill',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
