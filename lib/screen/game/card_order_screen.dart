import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/common/widgets/dialogs.dart';
import 'package:quick_game/model/trump_card_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/screen/game/game_abstract.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/toasts.dart';
import 'package:quick_game/widgets/trump_card.dart';

import '../../util.dart';

class CardOrderScreen extends StatefulWidget {
  const CardOrderScreen({Key? key}) : super(key: key);

  @override
  State<CardOrderScreen> createState() => _CardOrderScreenState();
}

class _CardOrderScreenState extends State<CardOrderScreen> implements GameAbstract {
  late StageInfoProvider stageInfoProvider;
  late List<TrumpCardModel> trumpCardModelList = [];

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
    Util.execAfterBinding(() {
      preGameModal();
    });
  }

  @override
  void preGameModal() {
    Dialogs.preGameModal(context: context, msg: "카드의 번호 순서에 맞게 카드를 눌러주세요", startFn: initGame);
  }

  @override
  void initGame() {
    isClickable = false;
    _resultMilliSecond = 0;
    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    clickIndex = 1;

    /// 카드 초기화
    trumpCardModelList.clear();
    for (int i = 1; i <= cardCount; i++) {
      trumpCardModelList.add(
        TrumpCardModel(
          key: UniqueKey(),
          cardNumber: i,
          cardShape: CardShape.values[Random().nextInt(CardShape.values.length - 1)],
          cardType: CardType.flip,
          flipSecond: randomSecond,
        ),
      );
    }
    trumpCardModelList.shuffle();

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


  /// 카드 클릭
  void onClick({required TrumpCardModel trumpCardModel}) {
    if (isClickable && clickIndex == trumpCardModel.cardNumber) {
      trumpCardModel.isClicked = true;
      clickIndex++;
    } else {
      initTimer!.cancel();
      String msg = "카드 번호 순서대로 눌러주세요";
      if(!isClickable) {
        msg = "카드가 뒤집히면, 눌러주세요";
      }
      Dialogs.recordFailDialog(context: context, subMsg: msg, retryFn: () {
        onStop();
        initGame();
      });
    }

    if (!isClickable || clickIndex != trumpCardModel.cardNumber) {

    } else {
      trumpCardModel.isClicked = true;
      clickIndex++;
    }

    /// 순서대로 전부 클릭했는지 체크
    if (clickIndex > cardCount) {
      onStop();
      onRecord();
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
            child: trumpCardModelList.isNotEmpty ? GridView.builder(
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
            ) : Container(),
          ),
        ),
      ),
    );
  }


}
