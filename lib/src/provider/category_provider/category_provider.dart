import 'package:flutter/material.dart';
import 'package:sakoon/src/models/category_model/Category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// class CategoryProvider extends ChangeNotifier {
//   late Database _database;
//   List<CategoryP> _categories = [];
//
//   List<CategoryP> get categories => _categories;
//
//   CategoryProvider() {
//     _initDatabase();
//   }
//
//   Future<void> _initDatabase() async {
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'categories_database.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT)',
//         );
//       },
//       version: 1,
//     );
//     await _loadCategories();
//   }
//
//   Future<void> _loadCategories() async {
//     final List<Map<String, dynamic>> maps = await _database.query('categories');
//     _categories = List.generate(maps.length, (i) {
//       return CategoryP(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//       );
//     });
//     notifyListeners();
//   }
//
//   Future<void> addCategory(String name) async {
//     final id = await _database.insert(
//       'categories',
//       {'name': name},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     _categories.add(CategoryP(id: id, name: name));
//     notifyListeners();
//   }
//
//   Future<void> updateCategory(CategoryP category) async {
//     await _database.update(
//       'categories',
//       {'name': category.name},
//       where: 'id = ?',
//       whereArgs: [category.id],
//     );
//     _categories[_categories.indexWhere((c) => c.id == category.id)] = category;
//     notifyListeners();
//   }
//
//   Future<void> deleteCategory(CategoryP category) async {
//     await _database.delete(
//       'categories',
//       where: 'id = ?',
//       whereArgs: [category.id],
//     );
//     _categories.removeWhere((c) => c.id == category.id);
//     notifyListeners();
//   }
// }

import 'package:path/path.dart';

class CategoryProvider extends ChangeNotifier {
  late Database _database;
  List<CategoryP> _categories = [];

  List<CategoryP> get categories => _categories;

  CategoryProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'categories_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
      version: 1,
    );
    await _loadCategories();
  }

  Future<void> _loadCategories() async {
    final List<Map<String, dynamic>> maps = await _database.query('categories');
    _categories = List.generate(maps.length, (i) {
      return CategoryP(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    final id = await _database.insert(
      'categories',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _categories.add(CategoryP(id: id, name: name));
    notifyListeners();
  }

  Future<void> updateCategory(CategoryP category) async {
    await _database.update(
      'categories',
      {'name': category.name},
      where: 'id = ?',
      whereArgs: [category.id],
    );
    _categories[_categories.indexWhere((c) => c.id == category.id)] = category;
    notifyListeners();
  }

  Future<void> deleteCategory(CategoryP category) async {
    await _database.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [category.id],
    );
    _categories.removeWhere((c) => c.id == category.id);
    notifyListeners();
  }
}
