import 'package:flutter/material.dart';
import 'package:quick_game/screen/game/speed_meter_game_screen.dart';

class Datas {
  static Map<String, Widget> gameScreenStringList = {
    "반응속도": SpeedMeterGameScreen(),
    "똑같은 카드 누르기": SpeedMeterGameScreen(),
    "순서대로 누르기": SpeedMeterGameScreen(),
    "카드 나누기": SpeedMeterGameScreen(),
    "짝맞추기": SpeedMeterGameScreen(),
  };
}