import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/data/datas.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/screen/record_stage_screen.dart';
import 'package:quick_game/screen/game/speed_meter_game_screen.dart';
import 'package:quick_game/screen/training_stage_screen.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/widgets/toasts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screenList = [
    const RecordStageScreen(),
    const TrainingStageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    StageInfoProvider stageInfoProvider = Provider.of(context, listen: true);

    return Scaffold(
      body: Center(
        child: _screenList.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 30,
        backgroundColor: ColorStyles.buttonBgColor.withRed(150),
        onPressed: () {
          Widget screenWidget = Datas.stageScreenStringMap[stageInfoProvider.currentStageInfoModel.stageId]!;
          Navigator.push(context, MaterialPageRoute(builder: (context) => screenWidget));
        },
        child: const Icon(Icons.play_arrow),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorStyles.buttonBgColor,
        items: [
          BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const Icon(
                      Icons.timer,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                    ),
              label: 'record'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const Icon(
                      Icons.run_circle,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.run_circle_outlined,
                      color: Colors.white,
                    ),
              label: 'training'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        //(1)
        showUnselectedLabels: false,
        //(1)
        type: BottomNavigationBarType.fixed, //(2)
      ),
    );
  }
}
