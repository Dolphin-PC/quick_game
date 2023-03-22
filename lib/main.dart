import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/db/db_helper.dart';
import 'package:quick_game/model/stage_info_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/screen/main_screen.dart';

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// DB 초기화
  await DBHelper().database;

  /// 스테이지 정보 초기화(최초 1회)
  await StageInfoModel.initData();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StageInfoProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}
