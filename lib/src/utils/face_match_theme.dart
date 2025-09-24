import 'package:flutter/material.dart';

extension FaceMatchTheme on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get darkBackground =>
      isDarkMode ? const Color(0xFF1A1C1D) : Colors.white;

  Color get primaryText => isDarkMode ? Colors.white : const Color(0xFF151619);
}
