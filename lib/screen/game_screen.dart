import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// 클릭 가능 여부
  bool isClickable = false;
  /// 시작 랜덤 시간
  int randomSecond = 0;
  /// widget 상태 값
  Color clickColor = Colors.blue;
  String clickText = '초록색으로 변하면 누르세요!\n(3~7초 뒤에 바뀌어요.)';
  String resultText = '측정 중';

  /// 기록 측정
  Timer? resultTimer, initTimer;
  int _resultMilliSecond = 0;


  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    isClickable = false;
    clickColor = Colors.blue;
    clickText = '초록색으로 변하면 누르세요!\n(3~7초 뒤에 바뀌어요.)';
    resultText = '측정 중';

    randomSecond = Random().nextInt(4) + 3; // (0~4)+3 랜덤

    initTimer = Timer(Duration(seconds: randomSecond), () {
      setState(() {
        isClickable = true;
        clickColor = Colors.green;
        clickText = '누르세요!';
        _onStart();
      });
    });
  }

  void onClick() {
    if(!isClickable) {
      resultText = '측정 실패!';
      initTimer!.cancel();
    } else {
      resultText = '${_resultMilliSecond}ms';
      _onStop();
    }

    setState(() {});
  }

  void _onStart() {
    resultTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      _resultMilliSecond++;
    });
  }

  void _onStop() {
    resultTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('순발력 측정'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(resultText),
              SizedBox(height: 20),
              GestureDetector(
                onTap: onClick,
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
