import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../base/theme.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: SpinKitFadingCircle(
          color: AppColors.green, // Customize the color as needed
          size: 50.0,
        ),
      );
    },
  );
}

void hideLoadingIndicator(BuildContext context) {
  Navigator.of(context).pop();
}
