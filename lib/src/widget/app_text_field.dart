import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.isObscured = false,
    this.bottomPadding = 16,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool isObscured;
  final double bottomPadding;

  OutlineInputBorder get _border {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 13),
      child: TextFormField(
        obscureText: isObscured,
        obscuringCharacter: '*',
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            fontSize: 13,
            color: Color(0xFF808080),
          ),
          labelText: hint,
          contentPadding: EdgeInsets.zero,
          errorBorder: _border,
          disabledBorder: _border,
          focusedErrorBorder: _border,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
