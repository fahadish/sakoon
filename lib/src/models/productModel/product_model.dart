class ProductC {
  final int id;
  final int categoryId;
  final String name;
  final double salePrice;
  final double purchasePrice;
  late final int quantity;
  final String imagePath;

  ProductC({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.salePrice,
    required this.purchasePrice,
    required this.quantity,
    required this.imagePath,
    this.selectedQuantity = 0, // Add selectedQuantity with default value 0
  });

  int selectedQuantity; // Add selectedQuantity property
}
