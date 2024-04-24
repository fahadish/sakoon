import 'dart:io';

import 'package:flutter/material.dart';

class ProductFormModel extends ChangeNotifier {
  String? name;
  double? purchasePrice;
  double? sellPrice;
  int? quantity;
  File? image;

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setPurchasePrice(String value) {
    purchasePrice = double.tryParse(value);
    notifyListeners();
  }

  void setSellPrice(String value) {
    sellPrice = double.tryParse(value);
    notifyListeners();
  }

  void setQuantity(String value) {
    quantity = int.tryParse(value);
    notifyListeners();
  }

  void setImage(File? value) {
    image = value;
    notifyListeners();
  }
}
