import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_game/main.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/styles/text_styles.dart';
import 'package:quick_game/widgets/card_controller.dart';

enum CardShape { diamond, clover, heart, spade, joker }

enum CardType { general, flip }

class TrumpCard extends StatefulWidget {
  const TrumpCard({
    Key? key,
    required this.cardShape,
    required this.cardType,
    required this.cardNumber,
    this.flipSecond = 3,
  }) : super(key: key);

  final CardShape cardShape;
  final CardType cardType;
  final int cardNumber;
  final int flipSecond;

  @override
  State<TrumpCard> createState() => _TrumpCardState();
}

class _TrumpCardState extends State<TrumpCard> {
  bool isFront = false;

  @override
  void initState() {
    super.initState();
    switch (widget.cardType) {
      case CardType.general:
        break;
      case CardType.flip:
        initFlipCard();
        break;
    }
  }

  void initFlipCard() {
    Timer(Duration(seconds: widget.flipSecond), () {
      setState(() {
        isFront = true;
        logger.i({'isFront': true});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.cardType) {
      case CardType.general:
        return CardFront(cardShape: widget.cardShape, cardNumber: widget.cardNumber);
      case CardType.flip:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget widget, Animation<double> animation) => CardController.flipAnimatedBuilder(widget, animation, isFront: isFront),
          child: isFront
              ? CardFront(
                  cardShape: widget.cardShape,
                  cardNumber: widget.cardNumber,
                )
              : const CardBack(),
        );
    }
  }
}

class CardFront extends StatelessWidget {
  const CardFront({
    super.key,
    required this.cardShape,
    required this.cardNumber,
  });

  final CardShape cardShape;
  final int cardNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(5.0, 5.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset('assets/images/${cardShape.name}.png'),
          ),
          Visibility(
            visible: cardShape != CardShape.joker,
            child: Text(
              '$cardNumber',
              style: TextStyles.cardText.copyWith(color: ColorStyles.bgPrimaryColor),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(5.0, 5.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset('assets/icons/quick_icon_color.png'),
          ),
        ],
      ),
    );
  }
}
