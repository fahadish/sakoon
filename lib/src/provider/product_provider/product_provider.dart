import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../components/orderHistory/order_history.dart';
import '../../models/category_model/Category_model.dart';
import 'package:path/path.dart';

import '../../models/productModel/product_model.dart';


class ProductProvider extends ChangeNotifier {
  late Database _database;
  List<ProductC> _products = [];
  Map<int, int> _selectedQuantities = {};
  String? customerName;


  List<ProductC> get products => _products;
  List<ProductC> get selectedProducts => _products.where((product) => _selectedQuantities.containsKey(product.id) && _selectedQuantities[product.id]! > 0).toList();

  ProductProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, categoryId INTEGER, name TEXT, salePrice REAL, purchasePrice REAL, quantity INTEGER, image TEXT)',
        );
      },
      version: 1,
    );
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    final List<Map<String, dynamic>> maps = await _database.query('products');
    _products = List.generate(maps.length, (i) {
      return ProductC(
        id: maps[i]['id'],
        categoryId: maps[i]['categoryId'],
        name: maps[i]['name'],
        purchasePrice: maps[i]['purchasePrice'],
        quantity: maps[i]['quantity'],
        salePrice: maps[i]['salePrice'],
        imagePath: maps[i]['image'],
      );
    });
    notifyListeners();
  }

  Future<void> addProduct({
    required int categoryId,
    required String name,
    required double salePrice,
    required double purchasePrice,
    required int quantity,
    required String imagePath,
  }) async {
    final id = await _database.insert(
      'products',
      {
        'categoryId': categoryId,
        'name': name,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
        'quantity': quantity,
        'image': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _products.add(ProductC(
      id: id,
      categoryId: categoryId,
      name: name,
      purchasePrice: purchasePrice,
      quantity: quantity,
      imagePath: imagePath,
      salePrice: salePrice,
    ));

    notifyListeners();
  }

  Future<void> deleteProduct(int productId) async {
    await _database.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );

    _products.removeWhere((product) => product.id == productId);
    _selectedQuantities.remove(productId);

    notifyListeners();
  }

  // void addSelectedProduct(ProductC product) {
  //   if (_selectedQuantities.containsKey(product.id)) {
  //     if (_selectedQuantities[product.id]! < product.quantity) {
  //       _selectedQuantities.update(product.id, (value) => value + 1);
  //       notifyListeners();
  //     }
  //   } else {
  //     _selectedQuantities[product.id] = 1;
  //     notifyListeners();
  //   }
  // }
  void addSelectedProduct(ProductC product) {
    if (_selectedQuantities.containsKey(product.id)) {
      if (_selectedQuantities[product.id]! < product.quantity) {
        _selectedQuantities.update(product.id, (value) => value + 1);
        notifyListeners();
        printSelectedProducts(); // Add this line to print selected products
      }
    } else {
      _selectedQuantities[product.id] = 1;
      notifyListeners();
      printSelectedProducts(); // Add this line to print selected products
    }
  }

  void removeSelectedProduct(ProductC product) {
    _selectedQuantities.update(product.id, (value) => 0, ifAbsent: () => 0);
    notifyListeners();
    printSelectedProducts(); // Add this line to print selected products
  }

  void printSelectedProducts() {
    print("Selected Products:");
    for (var product in _products) {
      if (_selectedQuantities.containsKey(product.id) && _selectedQuantities[product.id]! > 0) {
        print("${product.name} - Quantity: ${_selectedQuantities[product.id]}");
      }
    }
  }
  // void removeSelectedProduct(ProductC product) {
  //   _selectedQuantities.update(product.id, (value) => 0, ifAbsent: () => 0);
  //   notifyListeners();
  // }

  void clearSelectedProducts() {
    _selectedQuantities.clear();
    notifyListeners();
  }

  int getSelectedQuantity(int productId) {
    return _selectedQuantities[productId] ?? 0;
  }

  double getTotalBill() {
    double total = 0;
    for (var product in _products) {
      final selectedQuantity = _selectedQuantities[product.id] ?? 0;
      total += selectedQuantity * product.salePrice;
    }
    return total;
  }




  // void printBill(BuildContext context) {
  //   // Generate timestamp
  //   DateTime now = DateTime.now();
  //   String timestamp = "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
  //
  //   // Store order data
  //   List<Map<String, dynamic>> orderData = [];
  //   for (var product in selectedProducts) {
  //     final quantity = getSelectedQuantity(product.id);
  //     orderData.add({
  //       'productName': product.name,
  //       'quantity': quantity,
  //     });
  //   }
  //
  //   // Navigate to the order history screen
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => OrderHistoryScreen(
  //         customerName: customerName ?? 'Unknown', // Pass the customer's name
  //         orderData: orderData,
  //         timestamp: timestamp,
  //       ),
  //     ),
  //   );
  // }

  void printBill(BuildContext context) {
    // Generate timestamp
    DateTime now = DateTime.now();
    String timestamp = "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";

    // Store order data
    List<Map<String, dynamic>> orderData = [];
    for (var product in selectedProducts) {
      final quantity = getSelectedQuantity(product.id);
      orderData.add({
        'productName': product.name,
        'quantity': quantity,
      });
    }

    // Add order to order history
    addOrderToHistory(orderData, timestamp);

    // Navigate to the order history screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
    );
  }


  String? _customerName;
  List<Map<String, dynamic>> _orderHistory = [];

  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  // Method to set the customer's name
  void setCustomerName(String name) {
    _customerName = name;
    notifyListeners();
  }

  // Method to add an order to the order history
  void addOrderToHistory(List<Map<String, dynamic>> orderData, String timestamp) {
    _orderHistory.add({
      'customerName': _customerName ?? 'Unknown',
      'orderData': orderData,
      'timestamp': timestamp,
    });
    notifyListeners();
  }






}