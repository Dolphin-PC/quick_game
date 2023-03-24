import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/common/widgets/dialogs.dart';
import 'package:quick_game/main.dart';
import 'package:quick_game/model/trump_card_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/toasts.dart';
import 'package:quick_game/widgets/trump_card.dart';

class JokerScreen extends StatefulWidget {
  const JokerScreen({Key? key}) : super(key: key);

  @override
  State<JokerScreen> createState() => _JokerScreenState();
}

class _JokerScreenState extends State<JokerScreen> {
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

  void initGame() {
    int cardCount = 9;
    int jokerIndex = Random().nextInt(9) + 1;
    logger.i(jokerIndex);

    /// 게임 초기화
    isClickable = false;
    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    /// 카드 초기화
    for (int i = 1; i <= cardCount; i++) {
      if (i == jokerIndex) {
        trumpCardModelList.add(
          TrumpCardModel(
            cardNumber: 0,
            cardShape: CardShape.joker,
            cardType: CardType.flip,
            flipSecond: randomSecond,
          ),
        );
      } else {
        trumpCardModelList.add(
          TrumpCardModel(
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
      _onStart();
      setState(() {});
    });
  }

  /// 측정 시간 시작
  void _onStart() {
    resultTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      _resultMilliSecond++;
    });
  }

  /// 측정 시간 종료
  void _onStop() {
    resultTimer!.cancel();
  }

  /// 측정 클릭
  void onClick({required TrumpCardModel trumpCardModel}) {
    if (!isClickable || trumpCardModel.cardShape != CardShape.joker) {
      initTimer!.cancel();
      Toasts.show(msg: "측정 실패");
    } else {
      _onStop();
      _onRecord();
    }

    setState(() {});
  }

  /// 측정 성공
  void _onRecord() {
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
                  child: TrumpCard(trumpCardModel: trumpCardModelList[index]),
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
