import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/common/widgets/dialogs.dart';
import 'package:quick_game/main.dart';
import 'package:quick_game/model/pair_card_model.dart';
import 'package:quick_game/model/trump_card_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/toasts.dart';
import 'package:quick_game/widgets/trump_card.dart';

class CardMatchScreen extends StatefulWidget {
  const CardMatchScreen({Key? key}) : super(key: key);

  @override
  State<CardMatchScreen> createState() => _CardMatchScreenState();
}

class _CardMatchScreenState extends State<CardMatchScreen> {
  late StageInfoProvider stageInfoProvider;
  late List<PairCardModel> pairCardModelList = [];

  /// 클릭 가능 여부
  bool isClickable = false;

  /// 시작 랜덤 시간
  int randomSecond = 0;

  /// 기록 측정
  Timer? resultTimer, initTimer;
  int _resultMilliSecond = 0;
  int cardCount = 9;
  int clickIndex = 1;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    /// 게임 초기화
    isClickable = false;
    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    /// 카드 초기화
    for (int i = 1; i <= cardCount; i++) {
      pairCardModelList.add(
        PairCardModel(
          pairId: (i % 3) + 1,
          cardNumber: (i % 3) + 1,
          cardShape: CardShape.values[Random().nextInt(CardShape.values.length - 1)],
          cardType: CardType.flip,
          flipSecond: randomSecond,
        ),
      );
    }
    pairCardModelList.shuffle();

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

  List<int> clickedPairList = [];
  /// 카드 클릭
  void onClick({required PairCardModel pairCardModel}) {
    /// 이미 클릭된 상태일떄,
    if(pairCardModel.isClicked) return;

    /// 일단 UI 변경해주고
    pairCardModel.isClicked = true;

    /// 선택된 카드의 pairId
    int currentPairId = pairCardModel.pairId;
    if(clickedPairList.isNotEmpty && !clickedPairList.contains(currentPairId)) {
      int prevPairId = clickedPairList.first;
      for(var prevCardModel in pairCardModelList){
        if(prevCardModel.pairId == prevPairId) {
          prevCardModel.isClicked = false;
        }
      }
      clickedPairList = [];
    }

    clickedPairList.add(currentPairId);

    if(clickedPairList.length == 3) {
      clickedPairList = [];
    }

    logger.d(clickedPairList);


    if (pairCardModelList.every((element) => element.isClicked == true)) {
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
      Toasts.show(msg: "[신기록] 측정 성공!");
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
                    onClick(pairCardModel: pairCardModelList[index]);
                  },
                  child: TrumpCard(trumpCardModel: pairCardModelList[index]),
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
