import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_tictacto/services/databaseServices.dart';

class GameRoom extends StatefulWidget {
  final String roomId;

  GameRoom({Key? key, required this.roomId}) : super(key: key);

  @override
  _GameRoomState createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {
  final DatabaseService _databaseService = DatabaseService();
  late Stream<bool> _roomStream;

  @override
  void initState() {
    super.initState();
    _roomStream = _databaseService.roomStatusStream(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room'),
      ),
      body: StreamBuilder<bool>(
        stream: _roomStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildWaitingScreen();
          } else if (snapshot.hasError) {
            return _buildErrorScreen(snapshot.error.toString());
          } else {
            bool isFull = snapshot.data ?? false;
            return isFull ? _buildOrangeScreen() : _buildWaitingScreen();
          }
        },
      ),
    );
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Waiting for another user to join...'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Room Code: ${widget.roomId}'),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.roomId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Room code copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          // You can display more information about the room here
        ],
      ),
    );
  }

  Widget _buildOrangeScreen() {
    return Center(
      child: Container(
        color: Colors.orange,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Another user has joined the room.'),
            // You can display more information about the room here
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }
}