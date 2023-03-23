import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/common/widgets/dialogs.dart';
import 'package:quick_game/model/trump_card_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/toasts.dart';
import 'package:quick_game/widgets/trump_card.dart';

class CardSliceScreen extends StatefulWidget {
  const CardSliceScreen({Key? key}) : super(key: key);

  @override
  State<CardSliceScreen> createState() => _CardSliceScreenState();
}

class _CardSliceScreenState extends State<CardSliceScreen> {
  final CardSwiperController controller = CardSwiperController();

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
    initGame();
  }

  void initGame() {
    /// 게임 초기화
    isClickable = false;
    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    /// 카드 초기화
    for (int i = 1; i <= cardCount; i++) {
      trumpCardModelList.add(
        TrumpCardModel(
          cardNumber: i,
          cardShape: CardShape.values[Random().nextInt(CardShape.values.length - 1)],
          cardType: CardType.general,
          flipSecond: randomSecond,
        ),
      );
    }
    trumpCardModelList.shuffle();

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

  /// 카드 클릭
  void onClick({required TrumpCardModel trumpCardModel}) {
    if (!isClickable || clickIndex != trumpCardModel.cardNumber) {
      initTimer!.cancel();
      Toasts.show(msg: "측정 실패");
    } else {
      trumpCardModel.isClicked = true;
      clickIndex++;
    }

    if (clickIndex > cardCount) {
      _onStop();
      _onRecord();
    }

    setState(() {});
  }

  /// 카드 swipe
  void _onSwipe(int? previousIndex, int? currentIndex, CardSwiperDirection direction) {
    // TODO
    debugPrint(
      'the card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
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
          child: Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    Center(child: Text('hello')),
                    CardSwiper(
                      controller: controller,
                      cardsCount: trumpCardModelList.length,
                      onSwipe: _onSwipe,
                      isVerticalSwipingEnabled: false,
                      isLoop: false,
                      cardBuilder: (ctx, index) => TrumpCard(trumpCardModel: trumpCardModelList[index]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: 'left_btn',
                      onPressed: controller.swipeLeft,
                      backgroundColor: ColorStyles.borderColor,
                      child: const Icon(Icons.keyboard_arrow_left),
                    ),
                    FloatingActionButton(
                      heroTag: 'right_btn',
                      onPressed: controller.swipeRight,
                      backgroundColor: ColorStyles.borderColor,
                      child: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            ],
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
