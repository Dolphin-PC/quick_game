import 'package:flutter/material.dart';
import 'package:quick_game/styles/color_styles.dart';

class ButtonStyles {
  static defaultButton() {}
}

class ElevatedButtonStyles {
  static get negative => ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
  static get positive => ElevatedButton.styleFrom(backgroundColor: ColorStyles.bgPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
}
