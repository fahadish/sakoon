import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/nav.dart';
import '../../models/category_model/Category_model.dart';
import '../../provider/category_provider/category_provider.dart';
import 'add_category.dart';
import 'add_product_screen.dart';
import 'category_Products_Screen.dart'; // Import the AddProductScreen

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<CategoryP> _categories;

  @override
  void initState() {
    super.initState();
    _categories = Provider.of<CategoryProvider>(context, listen: false).categories;
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categories = Provider.of<CategoryProvider>(context).categories;
    // Update the TabController length if the number of categories changes
    if (_tabController.length != _categories.length) {
      _tabController.dispose();
      _tabController = TabController(length: _categories.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              AppNavigation.pushPage(context, AddCategoryScreen());
            },
            icon: Icon(Icons.add),
          )
        ],
        title: Text('Categories'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories.map((category) => Tab(text: category.name)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return CategoryProductsScreen(categoryId: category.id);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int tabIndex = _tabController.index;
          int categoryId = _categories[tabIndex].id;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(categoryId: categoryId),
            ),
          );
        },
        label: Text('Add Product'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
