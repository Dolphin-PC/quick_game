import 'package:flutter/material.dart';
import 'package:quick_game/screen/game_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('순발력 게임'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Text('Game Start'),
        ),
      ),
    );
  }
}
