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

import 'game_abstract.dart';

class CardMatchScreen extends StatefulWidget {
  const CardMatchScreen({Key? key}) : super(key: key);

  @override
  State<CardMatchScreen> createState() => _CardMatchScreenState();
}

class _CardMatchScreenState extends State<CardMatchScreen> implements GameAbstract {
  late StageInfoProvider stageInfoProvider;
  late List<PairCardModel> pairCardModelList = [];
  List<int> clickedPairList = [];

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

  @override
  void preGameModal() {
    Dialogs.recordFailDialog(context: context, subMsg: "박스가 파란색에서 초록색으로 바뀌면 눌러주세요", retryFn: initGame);
  }

  @override
  void initGame() {
    /// 게임 초기화
    isClickable = false;
    _resultMilliSecond = 0;
    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    /// 카드 초기화
    pairCardModelList.clear();
    for (int i = 1; i <= cardCount; i++) {
      pairCardModelList.add(
        PairCardModel(
          pairId: (i % 3) + 1,
          cardNumber: (i % 3) + 1,
          cardShape: CardShape.values[(i % 3)],
          cardType: CardType.flip,
          flipSecond: randomSecond,
        ),
      );
    }
    pairCardModelList.shuffle();

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
    resultTimer!.cancel();
  }


  /// 카드 클릭
  void onClick({required PairCardModel pairCardModel}) {
    if(!isClickable || pairCardModel.isClicked) return;

    pairCardModel.isClicked = true;

    int currentPairId = pairCardModel.pairId;
    /// 다른 카드 선택했을 경우
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

    if (pairCardModelList.every((element) => element.isClicked == true)) {
      onStop();
      onRecord();
    }

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
  void dispose() {
    initTimer?.cancel();
    resultTimer?.cancel();
    super.dispose();
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

}
