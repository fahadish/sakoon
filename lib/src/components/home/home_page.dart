import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakoon/src/base/nav.dart';
import 'package:sakoon/src/components/categoryScreen/add_category.dart';
import 'package:sakoon/src/models/productModel/product_model.dart';
import 'package:sakoon/src/models/task_model/task_model.dart';
import '../../provider/Task_provider/task_provider.dart';
import '../../provider/auth_provider/auth_provider.dart';
import '../../provider/category_provider/category_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/product_provider/product_provider.dart';
import '../../widget/app_text_field.dart';
import '../cartScreen/cart_screen.dart';
import '../categoryScreen/add_product_screen.dart';
import '../categoryScreen/listing_screen.dart';
import '../orderHistory/order_history.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Catalog'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: CategoryTabs(),
      floatingActionButton: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            backgroundColor: Colors.green,
            splashColor: Colors.lightGreenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Icon(Icons.shopping_cart),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green[900],
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.shopping_basket),
              color: Colors.white,
              onPressed: () {
                AppNavigation.pushPage(context, AddCategoryScreen());
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                AppNavigation.pushPage(context, CategoryScreen());
              },
            ),
            IconButton(
              icon: Icon(Icons.history),
              color: Colors.white,
              onPressed: () {

AppNavigation.pushPage(context, OrderHistoryScreen());
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                // Implement according to your requirements
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CategoryTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: categoryProvider.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
          bottom: TabBar(
            tabs: categoryProvider.categories.map((category) => Tab(text: category.name)).toList(),
          ),
        ),
        body: TabBarView(
          children: categoryProvider.categories.map((category) {
            final products = productProvider.products.where((product) => product.categoryId == category.id).toList();
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final ProductC product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.product.selectedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Card(
      color: productProvider.selectedProducts.contains(widget.product) ? Colors.green.withOpacity(0.3) : null,
      child: ListTile(
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: widget.product.imagePath.isNotEmpty
                ? DecorationImage(
              image: FileImage(File(widget.product.imagePath)),
              fit: BoxFit.cover,
            )
                : null,
          ),
        ),
        title: Text(
          widget.product.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sale Price: ${widget.product.salePrice.toString()}'),
            SizedBox(height: 2),
            Text('Available Quantity: ${widget.product.quantity.toString()}'),
            SizedBox(height: 2),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 0) {
                      setState(() {
                        quantity--;
                        widget.product.selectedQuantity--;
                        if (widget.product.selectedQuantity == 0) {
                          productProvider.removeSelectedProduct(widget.product);
                        }
                      });
                    }
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (quantity < widget.product.quantity) {
                      setState(() {
                        quantity++;
                        widget.product.selectedQuantity++;
                        productProvider.addSelectedProduct(widget.product);
                      });
                    }
                  },
                ),
              ],
            ),
            Text('Total Price: ${(widget.product.salePrice * quantity).toString()}'),
          ],
        ),
      ),
    );
  }
}
