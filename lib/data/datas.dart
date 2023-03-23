import 'package:flutter/material.dart';
import 'package:quick_game/screen/game/card_order_screen.dart';
import 'package:quick_game/screen/game/joker_screen.dart';
import 'package:quick_game/screen/game/speed_meter_game_screen.dart';

class Datas {
  static Map<String, String> stageMap = {
    "speed_meter": "반응속도",
    "joker": "조커 맞추기",
    "card_order": "순서대로 누르기",
    "card_slice": "카드 나누기",
    "card_match": "짝맞추기",
  };

  static Map<String, Widget> stageScreenStringMap = {
    "speed_meter": const SpeedMeterGameScreen(),
    "joker": const JokerScreen(),
    "card_order": const CardOrderScreen(),
    "card_slice": const SpeedMeterGameScreen(),
    "card_match": const SpeedMeterGameScreen(),
  };
}
