import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/common/widgets/dialogs.dart';
import 'package:quick_game/main.dart';
import 'package:quick_game/model/trump_card_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/screen/game/game_abstract.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/toasts.dart';
import 'package:quick_game/widgets/trump_card.dart';

class JokerScreen extends StatefulWidget {
  const JokerScreen({Key? key}) : super(key: key);

  @override
  State<JokerScreen> createState() => _JokerScreenState();
}

class _JokerScreenState extends State<JokerScreen> implements GameAbstract {
  late StageInfoProvider stageInfoProvider;
  late List<TrumpCardModel> trumpCardModelList = [];

  /// 클릭 가능 여부
  bool isClickable = false;

  /// 시작 랜덤 시간
  int randomSecond = 0;

  /// 기록 측정
  Timer? resultTimer, initTimer;
  int _resultMilliSecond = 0;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  void initGame() {
    isClickable = false;
    _resultMilliSecond = 0;
    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    int cardCount = 9;
    int jokerIndex = Random().nextInt(9) + 1;


    /// 카드 초기화
    trumpCardModelList.clear();
    for (int i = 1; i <= cardCount; i++) {
      if (i == jokerIndex) {
        trumpCardModelList.add(
          TrumpCardModel(
            key: UniqueKey(),
            cardNumber: 0,
            cardShape: CardShape.joker,
            cardType: CardType.flip,
            flipSecond: randomSecond,
          ),
        );
      } else {
        trumpCardModelList.add(
          TrumpCardModel(
            key: UniqueKey(),
            cardNumber: Random().nextInt(9) + 1,
            cardShape: CardShape.values[Random().nextInt(CardShape.values.length - 1)],
            cardType: CardType.flip,
            flipSecond: randomSecond,
          ),
        );
      }
    }

    initTimer = Timer(Duration(seconds: randomSecond), () {
      isClickable = true;
      onStart();
      setState(() {});
    });
    setState(() {});
  }

  @override
  void onStart() {
    resultTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      _resultMilliSecond++;
    });
  }

  @override
  void onStop() {
    resultTimer?.cancel();
  }

  /// 클릭 이벤트
  void onClick({required TrumpCardModel trumpCardModel}) {
    if(isClickable && trumpCardModel.cardShape == CardShape.joker) {
      return setState(() {
        onStop();
        onRecord();
      });
    }

    initTimer!.cancel();
    String msg = "조커 카드를 눌러주세요.";
    if(!isClickable) {
      msg = "카드가 뒤집히면, 눌러주세요.";
    }
    Dialogs.recordFailDialog(context: context, subMsg: msg, retryFn: () {
      onStop();
      initGame();
    });

    setState(() {});
  }

  @override
  void onRecord() {
    /// 기록 측정
    int? prevRecordTime = stageInfoProvider.currentStageInfoModel.recordTime;
    if (prevRecordTime == null || prevRecordTime > _resultMilliSecond) {
      stageInfoProvider.setRecordTime(_resultMilliSecond);
      Toasts.show(msg: "[신기록] 달성!");
    }
    Dialogs.recordDialog(context: context, resultMilliSecond: _resultMilliSecond);
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
                return GestureDetector(
                  onTap: () {
                    onClick(trumpCardModel: trumpCardModelList[index]);
                  },
                  child: TrumpCard(
                    trumpCardModel: trumpCardModelList[index],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    initTimer?.cancel();
    resultTimer?.cancel();
    super.dispose();
  }
}
