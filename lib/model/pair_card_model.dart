import 'package:quick_game/model/trump_card_model.dart';

class PairCardModel extends TrumpCardModel {
  final int pairId;

  PairCardModel({
    required CardShape cardShape,
    required CardType cardType,
    required int cardNumber,
    int? flipSecond,
    bool isClicked = false,
    CardDirection? cardDirection,
    required this.pairId,
  }) : super(cardShape: cardShape, cardType: cardType, cardNumber: cardNumber, flipSecond: flipSecond, isClicked: isClicked, cardDirection: cardDirection);
}
