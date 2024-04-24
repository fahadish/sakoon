import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get agricultureTheme {
    return ThemeData(
      primaryColor: AppColors.green,
      scaffoldBackgroundColor: AppColors.lightGreen,
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        // Adjust text styles for better readability
        bodyText1: TextStyle(fontSize: 16.0, color: AppColors.darkGrey),
        bodyText2: TextStyle(fontSize: 14.0, color: AppColors.darkGrey),
        headline6: TextStyle(fontSize: 18.0, color: AppColors.darkGrey, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.green,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkGrey), toolbarTextStyle: TextTheme(
          headline6: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ).bodyText2, titleTextStyle: TextTheme(
          headline6: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ).headline6,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          padding: EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.green, textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.greenAccent),
    );
  }
}

class AppColors {
  static const green = Color(0xFF2ECC71);
  static const greenAccent = Color(0xFF27AE60);
  static const lightGreen = Color(0xFFF2F9F2);
  static const darkGrey = Color(0xFF333333);
}
