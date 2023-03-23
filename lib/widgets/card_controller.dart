import 'dart:math';

import 'package:flutter/material.dart';

class CardController {
  static Widget flipAnimatedBuilder(Widget widget, Animation<double> animation, {required bool isFront}) {
    var pi = 3.14;
    final rotate = Tween(begin: pi, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: rotate,
      child: widget,
      builder: (_, widget) {
        final isBack = isFront ? widget?.key == const ValueKey(false) : widget?.key != const ValueKey(false);

        final value = isBack ? min(rotate.value, pi / 2) : rotate.value;

        return Transform(
          transform: Matrix4.rotationY(value),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
