import 'package:flutter/material.dart';

import '../../models/productModel/product_model.dart';
import '../product_provider/product_provider.dart';

class CartProvider extends ChangeNotifier {
  Map<int, int> _cartItems = {}; // Map to store cart items with productId and quantity
  ProductProvider _productProvider; // Reference to the ProductProvider

  CartProvider(this._productProvider);

  Map<int, int> get cartItems => _cartItems;

  void addToCart(ProductC product) {
    if (_cartItems.containsKey(product.id)) {
      // If item already exists in cart, increment quantity if available in inventory
      if (_cartItems[product.id]! < product.quantity) {
        _cartItems.update(product.id, (value) => value + 1);
      } else {
        // Optionally, you can show a message or handle out-of-stock scenario
        // For now, let's just print a message
        print('Item out of stock!');
      }
    } else {
      // Add item to cart with quantity 1 if available in inventory
      if (product.quantity > 0) {
        _cartItems[product.id] = 1;
      } else {
        // Optionally, you can show a message or handle out-of-stock scenario
        // For now, let's just print a message
        print('Item out of stock!');
      }
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.remove(productId);
      notifyListeners();
    }
  }

  double getTotalBill() {
    double total = 0;
    _cartItems.forEach((productId, quantity) {
      final product = _productProvider.products.firstWhere((p) => p.id == productId);
      if (product != null) {
        total += quantity * product.salePrice;
      }
    });
    return total;
  }

  void checkout() {
    // Update inventory quantities based on items purchased
    _cartItems.forEach((productId, quantity) {
      final product = _productProvider.products.firstWhere((p) => p.id == productId);
      if (product != null) {
        if (quantity <= product.quantity) {
          // Reduce inventory quantity by quantity purchased
          product.quantity -= quantity;
          // Optionally, you can update database here if required
        } else {
          // Optionally, you can handle insufficient inventory scenario
          // For now, let's just print a message
          print('Insufficient inventory for product ${product.name}');
        }
      }
    });
    // Clear cart after successful checkout
    _cartItems.clear();
    notifyListeners();
  }
}