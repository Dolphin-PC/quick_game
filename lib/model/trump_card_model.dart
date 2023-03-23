enum CardShape { diamond, clover, heart, spade, joker }

enum CardType { general, flip }

class TrumpCardModel {
  TrumpCardModel({
    required this.cardShape,
    required this.cardType,
    required this.cardNumber,
    this.flipSecond = 3,
    this.isClicked = false,
  });

  final CardShape cardShape;
  final CardType cardType;
  final int cardNumber;
  final int flipSecond;
  bool isClicked;
}
