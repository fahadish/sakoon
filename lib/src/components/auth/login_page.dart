import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../base/theme.dart';
import '../../provider/auth_provider/auth_provider.dart';
import '../../widget/app_text_field.dart';
import '../../widget/elevated_button.dart';

// Import your other files and dependencies

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    assert(() {
      emailController.text = 'eve.holt@reqres.in';
      passwordController.text = 'cityslicka';
      return true;
    }());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Sakoon',
              style: TextStyle(
                color: AppColors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Form(
              key: formKey,
              autovalidateMode: autoValidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v?.isEmpty ?? true) {
                        return 'Email is required.';
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9.+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
                      ).hasMatch(v ?? '')) {
                        return 'Please enter valid email.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    controller: passwordController,
                    isObscured: true,
                    hint: 'Password',
                    validator: (v) {
                      if (v?.isEmpty ?? true) {
                        return 'Password is required.';
                      } else if ((v?.length ?? 0) < 6) {
                        return 'Password must be 6 characters long.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password?'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return authProvider.isLoading
                          ? Center(
                        child: SpinKitWave(
                          color: AppColors.green, // Customize the color as needed
                          size: 50.0, // Customize the size as needed

                        ),
                      )
                          : MyElevatedButton(
                        text: 'Login',
                        textColor: Colors.white,
                        fontSize: 20,
                        onPressed: () async {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            autoValidateMode = AutovalidateMode.onUserInteraction;
                            setState(() {});
                            return;
                          }

                          // Use the LoginProvider for login logic
                          await Provider.of<AuthProvider>(context, listen: false).loginUser(
                            email: emailController.text.toLowerCase().trim(),
                            password: passwordController.text,
                            context: context,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'New Member? ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF808080),
                      ),
                      children: [
                        TextSpan(
                          text: 'Create an Account',
                          style: TextStyle(color: AppColors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
