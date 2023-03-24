import 'package:flutter/material.dart';

enum CardShape { diamond, clover, heart, spade, joker }
enum CardDirection { left, right }

enum CardType { general, flip }

class TrumpCardModel {
  TrumpCardModel({
    this.key,
    required this.cardShape,
    required this.cardType,
    required this.cardNumber,
    this.cardDirection,
    this.flipSecond = 3,
    this.isClicked = false,
  });
  Key? key;
  final CardShape cardShape;
  final CardType cardType;
  final int cardNumber;
  final CardDirection? cardDirection;
  final int? flipSecond;
  bool isClicked;
}
