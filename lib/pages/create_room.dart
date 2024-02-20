import 'package:flutter/material.dart';
import 'package:new_tictacto/models/player.dart';
import 'package:new_tictacto/models/room.dart';
import 'package:new_tictacto/pages/game_room.dart';
import 'package:new_tictacto/services/databaseServices.dart';

class CreateRoomScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  static String routeName = '/create-room';

  CreateRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create Room',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your nickname',
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                Player player =
                    Player(nickname: _nameController.text, playerType: 'X');
                Room room = Room(player1: player);

                String roomId = await _databaseService.createRoom(room, player);

                print('Room created with ID: $roomId');

                _navigateToRoomScreen(context, roomId);

                // List<Player> players = [];
                // Player player = Player(
                //   nickname: _nameController.text,
                //   playerType: 'X',
                // );
                // players.add(player);
                // // Room room = Room(players: players, turn: player);
                // _nameController.clear();
                // _playerDatabase.addPlayer(player);
                // print(_playerDatabase.getPlayer());
                // // _databaseService.addRoom(room);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRoomScreen(BuildContext context, String roomId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameRoom(roomId: roomId)),
    );
  }
}
