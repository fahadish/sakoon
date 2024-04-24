// my_app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakoon/src/provider/ProductFormProvider.dart';
import 'package:sakoon/src/provider/Task_provider/task_provider.dart';
import 'package:sakoon/src/provider/auth_provider/auth_provider.dart';
import 'package:sakoon/src/provider/cart_provide/cart_provider.dart';
import 'package:sakoon/src/provider/category_provider/category_provider.dart';
import 'package:sakoon/src/provider/product_provider.dart';
import 'package:sakoon/src/provider/product_provider/product_provider.dart';
import 'package:sakoon/src/utils/Local_Storage_Util.dart';
import 'base/theme.dart';
import 'components/auth/login_page.dart';
import 'components/home/home_page.dart';
import 'models/authModel/auth_model.dart';

// class MyApp extends StatelessWidget {
//   const MyApp._();
//
//   static Future<void> initializeAndRun() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     runApp(const MyApp._());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<UserModel?>(
//       future: LocalStorageUtil.loadUserData(),
//       builder: (context, snapshot) {
//         return MultiProvider(
//           providers: [
//             ChangeNotifierProvider<AuthProvider>(
//               create: (context) => AuthProvider(),
//             ),
//
//             ChangeNotifierProvider<TaskProvider>(
//               create: (context) => TaskProvider(),
//             ),
//             ChangeNotifierProvider<ProductProvider>(
//               create: (context) => ProductProvider(),
//             ),
//             ChangeNotifierProvider<ProductFormModel>(
//               create: (context) => ProductFormModel(),
//             ),
//             ChangeNotifierProvider<CategoryProvider>(
//               create: (context) => CategoryProvider(),
//             ),
//             ChangeNotifierProvider<CartProvider>(
//               create: (context) => CartProvider(_productProvider),
//             ),
//
//
//           ],
//           child: MaterialApp(
//             theme: AppTheme.agricultureTheme,
//             title: 'Task',
//             home: snapshot.hasData ? HomePage() : const LoginPage(),
//           ),
//         );
//       },
//     );
//   }
// }
class MyApp extends StatelessWidget {
  const MyApp._();

  static Future<void> initializeAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp._());
  }

  @override
  Widget build(BuildContext context) {
    // Initialize _productProvider here
    final _productProvider = ProductProvider();

    return FutureBuilder<UserModel?>(
      future: LocalStorageUtil.loadUserData(),
      builder: (context, snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider(),
            ),
            ChangeNotifierProvider<TaskProvider>(
              create: (context) => TaskProvider(),
            ),
            ChangeNotifierProvider<ProductProvider>.value(
              value: _productProvider,
            ),
            ChangeNotifierProvider<ProductFormModel>(
              create: (context) => ProductFormModel(),
            ),
            ChangeNotifierProvider<CategoryProvider>(
              create: (context) => CategoryProvider(),
            ),
            // Pass _productProvider to CartProvider constructor
            ChangeNotifierProvider<CartProvider>(
              create: (context) => CartProvider(_productProvider),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.agricultureTheme,
            title: 'Task',
            home: snapshot.hasData ? HomePage() : const LoginPage(),
          ),
        );
      },
    );
  }
}
