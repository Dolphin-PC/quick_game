import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/common/widgets/dialogs.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/screen/game/game_abstract.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/util.dart';
import 'package:quick_game/widgets/toasts.dart';

class SpeedMeterGameScreen extends StatefulWidget {
  const SpeedMeterGameScreen({Key? key}) : super(key: key);

  @override
  State<SpeedMeterGameScreen> createState() => _SpeedMeterGameScreenState();
}

class _SpeedMeterGameScreenState extends State<SpeedMeterGameScreen> implements GameAbstract {
  late StageInfoProvider stageInfoProvider;

  /// 클릭 가능 여부
  bool isClickable = false;

  /// 시작 랜덤 시간
  int randomSecond = 0;

  /// widgets 상태 값
  Color clickColor = Colors.blue;
  String clickText = '초록색으로 변하면 누르세요!\n(3~7초 뒤에 바뀌어요.)';

  /// 기록 측정
  Timer? resultTimer, initTimer;
  int _resultMilliSecond = 0;

  @override
  void initState() {
    super.initState();

    Util.execAfterBinding(() {
      preGameModal();
    });
  }

  @override
  void preGameModal() {
    Dialogs.preGameModal(context: context, msg: "박스가 파란색에서\n초록색으로 바뀌면 눌러주세요", startFn: initGame);
  }

  @override
  void initGame() {
    _resultMilliSecond = 0;
    isClickable = false;
    clickColor = Colors.blue;
    clickText = '초록색으로 변하면 누르세요!\n(3~7초 뒤에 바뀌어요.)';

    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    initTimer = Timer(Duration(seconds: randomSecond), () {
      setState(() {
        isClickable = true;
        clickColor = Colors.green;
        clickText = '누르세요!';
        onStart();
      });
    });
  }

  /// 측정 클릭
  void onClick() {
    if (!isClickable) {
      initTimer!.cancel();
      Dialogs.recordFailDialog(context: context, subMsg: "색이 바뀌면, 눌러주세요.", retryFn: () {
        onStop();
        initGame();
      });
    } else {
      onStop();
      onRecord();
    }

    setState(() {});
  }

  @override
  void onRecord() {
    clickText = '측정 결과 : ${_resultMilliSecond}ms';

    /// 기록 측정
    int? prevRecordTime = stageInfoProvider.currentStageInfoModel.recordTime;
    if (prevRecordTime == null || prevRecordTime > _resultMilliSecond) {
      stageInfoProvider.setRecordTime(_resultMilliSecond);
      Toasts.show(msg: "[신기록] 달성!");
    }
    Dialogs.recordDialog(context: context, resultMilliSecond: _resultMilliSecond);
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: onClick,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    color: clickColor,
                    child: Center(
                      child: Text(
                        clickText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
