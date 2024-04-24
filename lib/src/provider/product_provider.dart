// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../models/category_model/category_model.dart';
//
// class ProductProvider extends ChangeNotifier {
//   List<Product> _products = [];
//
//   List<Product> get products => _products;
//
//   Future<void> loadProducts() async {
//     final Database database = await _openDatabase();
//     final List<Map<String, dynamic>> maps = await database.query('products');
//
//     _products = List.generate(maps.length, (i) {
//       return Product(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//         purchasePrice: maps[i]['purchasePrice'],
//         sellPrice: maps[i]['sellPrice'],
//         image: maps[i]['image'],
//         quantity: maps[i]['quantity'],
//       );
//     });
//
//     notifyListeners();
//   }
//
//   Future<void> increaseProductQuantity(int productId) async {
//     final Database database = await _openDatabase();
//     await database.rawUpdate(
//         'UPDATE products SET quantity = quantity + 1 WHERE id = ?', [productId]);
//     await loadProducts(); // Reload products after updating quantity
//   }
//
//
//
//   Future<Database> _openDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String dbPath = path.join(documentsDirectory.path, 'products.db');
//     return openDatabase(dbPath, onCreate: (db, version) {
//       return db.execute(
//           "CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, purchasePrice REAL, sellPrice REAL, image TEXT, quantity INTEGER)");
//     }, version: 1);
//   }
//
//   Future<void> addProduct({
//     required String name,
//     required double purchasePrice,
//     required double sellPrice,
//     required String image,
//     required int quantity,
//   }) async {
//     final Database database = await _openDatabase();
//     await database.rawInsert(
//       'INSERT INTO products(name, purchasePrice, sellPrice, image, quantity) VALUES (?, ?, ?, ?, ?)',
//       [name, purchasePrice, sellPrice, image, quantity],
//     );
//     await loadProducts(); // Reload products after adding a new product
//   }
//
//   Future<void> updateProductQuantity(int productId, int newQuantity) async {
//     final Database database = await _openDatabase();
//     await database.rawUpdate(
//       'UPDATE products SET quantity = ? WHERE id = ?',
//       [newQuantity, productId],
//     );
//     await loadProducts(); // Reload products after updating quantity
//   }
//
//   Future<void> deleteProduct(int productId) async {
//     final Database database = await _openDatabase();
//     await database.rawDelete('DELETE FROM products WHERE id = ?', [productId]);
//     await loadProducts(); // Reload products after deleting
//   }
//
// }
