import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/main.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/trump_card.dart';

class JokerScreen extends StatefulWidget {
  const JokerScreen({Key? key}) : super(key: key);

  @override
  State<JokerScreen> createState() => _JokerScreenState();
}

class _JokerScreenState extends State<JokerScreen> {
  late StageInfoProvider stageInfoProvider;
  late List<Widget> trumpCardList = [];

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    int cardCount = 9;
    int jokerIndex = Random().nextInt(9) + 1;
    logger.i(jokerIndex);

    /// 카드 초기화
    for (int i = 1; i <= cardCount; i++) {
      if (i == jokerIndex) {
        trumpCardList.add(
          const TrumpCard(
            cardNumber: 0,
            cardShape: CardShape.joker,
            cardType: CardType.flip,
          ),
        );
      } else {
        trumpCardList.add(
          TrumpCard(
            cardNumber: Random().nextInt(9) + 1,
            cardShape: CardShape.values[Random().nextInt(CardShape.values.length - 1)],
            cardType: CardType.flip,
          ),
        );
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    stageInfoProvider = Provider.of(context, listen: false);

    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorStyles.bgPrimaryColor,
        centerTitle: true,
        title: Text("${stageInfoProvider.currentStageInfoModel.stageName}"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1 / 1.5,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return trumpCardList[index];
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
