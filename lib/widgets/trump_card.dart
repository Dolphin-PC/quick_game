import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_game/main.dart';
import 'package:quick_game/model/trump_card_model.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/styles/text_styles.dart';
import 'package:quick_game/widgets/card_controller.dart';

class TrumpCard extends StatefulWidget {
  const TrumpCard({Key? key, required this.trumpCardModel}) : super(key: key);

  final TrumpCardModel trumpCardModel;

  @override
  State<TrumpCard> createState() => _TrumpCardState();
}

class _TrumpCardState extends State<TrumpCard> {
  bool isFront = false;
  Timer? flipTimer;

  @override
  void initState() {
    super.initState();
    switch (widget.trumpCardModel.cardType) {
      case CardType.general:
        break;
      case CardType.flip:
        initFlipCard();
        break;
    }
  }

  @override
  void dispose() {
    flipTimer?.cancel();
    super.dispose();
  }

  void initFlipCard() {
    flipTimer = Timer(Duration(seconds: widget.trumpCardModel.flipSecond!), () {
      setState(() {
        isFront = true;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    switch (widget.trumpCardModel.cardType) {
      case CardType.general:
        return CardFront(trumpCardModel: widget.trumpCardModel);
      case CardType.flip:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget widget, Animation<double> animation) => CardController.flipAnimatedBuilder(widget, animation, isFront: isFront),
          child: isFront ? CardFront(trumpCardModel: widget.trumpCardModel) : const CardBack(),
        );
    }
  }
}

class CardFront extends StatelessWidget {
  const CardFront({
    super.key,
    required this.trumpCardModel,
  });

  final TrumpCardModel trumpCardModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: trumpCardModel.isClicked ? Colors.grey : Colors.white,
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
            child: Image.asset('assets/images/${trumpCardModel.cardShape.name}.png'),
          ),

          /// 조커카드가 아닐 경우, 하단 텍스트 표시
          Visibility(
            visible: trumpCardModel.cardShape != CardShape.joker && trumpCardModel.cardDirection == null,
            child: Text(
              '${trumpCardModel.cardNumber}',
              style: TextStyles.cardText.copyWith(color: ColorStyles.bgPrimaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: trumpCardModel.cardDirection != null,
            child: Icon(
              trumpCardModel.cardDirection == CardDirection.left ? Icons.arrow_circle_left_rounded : Icons.arrow_circle_right_rounded,
              color: ColorStyles.bgPrimaryColor,
              size: 100,
            ),
          ),
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
