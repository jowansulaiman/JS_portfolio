// lib/utils/responsive_helper.dart
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  bool get isPhone => MediaQuery.of(this).size.width < 768;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 768 &&
          MediaQuery.of(this).size.width < 1200;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;
}