import 'package:flutter/material.dart';
import 'package:quick_game/screen/record_stage_screen.dart';
import 'package:quick_game/screen/training_stage_screen.dart';

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
    return Scaffold(
      body: Center(
        child: _screenList.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const Icon(
                      Icons.timer,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.timer_outlined,
                      color: Colors.black,
                    ),
              label: 'record'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const Icon(
                      Icons.run_circle,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.run_circle_outlined,
                      color: Colors.black,
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
