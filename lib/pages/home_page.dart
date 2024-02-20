import 'package:flutter/material.dart';
import 'package:new_tictacto/pages/create_room.dart';
import 'package:new_tictacto/pages/join_room.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';

  const MainMenuScreen({Key? key}) : super(key: key);

  void _navigateToCreateRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void _navigateToJoinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TicTacToe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToCreateRoom(context),
              child: const Text('Create Room'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToJoinRoom(context),
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
