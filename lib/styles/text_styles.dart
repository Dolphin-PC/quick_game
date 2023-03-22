import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_game/styles/color_styles.dart';

// https://fonts.google.com/
class TextStyles {
  static TextStyle get titleText => GoogleFonts.notoSans(color: ColorStyles.textColor, fontSize: 45, fontWeight: FontWeight.w700);
  static TextStyle get cardText => GoogleFonts.notoSans(color: ColorStyles.textColor, fontSize: 25, fontWeight: FontWeight.w400);
  static TextStyle get plainText => GoogleFonts.notoSans(color: ColorStyles.textColor, fontSize: 15, fontWeight: FontWeight.w400);
  static TextStyle get labelText => GoogleFonts.notoSans(color: ColorStyles.textColor, fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle get buttonText => GoogleFonts.notoSans(color: ColorStyles.textColor, fontSize: 15, fontWeight: FontWeight.w400);

  static TextStyle plainTexts([double fontSize = 15]) {
    return GoogleFonts.notoSans(color: ColorStyles.textColor, fontSize: fontSize, fontWeight: FontWeight.w400);
  }
}
