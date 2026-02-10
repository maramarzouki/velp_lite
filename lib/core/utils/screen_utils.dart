import 'package:flutter/material.dart';

class ScreenUtils {
  // No need to use BuildContext
  static double getScreenWidth() {
    return MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .size
        .width;
  }

  static double getScreenHeight() {
    return MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .size
        .height;
  }
}
