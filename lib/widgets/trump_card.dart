import 'package:flutter/material.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/styles/text_styles.dart';

enum CardShape { diamond, clover, heart, spade }

class TrumpCard extends StatelessWidget {
  const TrumpCard({
    Key? key,
    required this.cardShape,
    required this.cardNumber,
    required this.width,
    required this.height,
  }) : super(key: key);

  final CardShape cardShape;
  final int cardNumber;
  final double width, height;

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
      // height: height,
      // width: width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal : width/5),
            child: Image.asset('assets/images/${cardShape.name}.png'),
          ),
          Text('$cardNumber', style: TextStyles.cardText.copyWith(color: ColorStyles.bgPrimaryColor),)
        ],
      ),
    );
  }
}
