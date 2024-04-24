import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/category_provider/category_provider.dart';
import '../../widget/elevated_button.dart';

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 26.0),

          MyElevatedButton(
            text: ' Add Category ',
            textColor: Colors.white,
            fontSize: 20,
            onPressed: () async {   final categoryName = _categoryController.text;
            if (categoryName.isNotEmpty) {
              Provider.of<CategoryProvider>(context, listen: false)
                  .addCategory(categoryName);
              Navigator.pop(context);
            } else {
              // Show error message or handle empty category name
            }
            },
          ),

          ],
        ),
      ),
    );
  }
}
