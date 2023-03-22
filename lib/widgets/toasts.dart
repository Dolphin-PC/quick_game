import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_game/styles/color_styles.dart';

class Toasts {
  static show({required String msg}) {
    close();
    return Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: ColorStyles.borderColor, textColor: Colors.white, fontSize: 16.0);
  }

  static close() {
    return Fluttertoast.cancel();
  }
}
