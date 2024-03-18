// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/player.dart';
import 'package:new_tictacto/game/square.dart';
import 'dart:async';
import 'dart:math';
import 'package:new_tictacto/services/databaseServices.dart';
import 'package:new_tictacto/pages/home_page.dart';

class MultiplayerApp extends StatefulWidget {
  static String routeName = '/multiplayer-page';
  final String roomId;
  bool isTurn;
  final String player;

  MultiplayerApp(
      {super.key,
      required this.roomId,
      required this.isTurn,
      required this.player});

  @override
  _MultiplayerAppState createState() => _MultiplayerAppState();
}

class _MultiplayerAppState extends State<MultiplayerApp> {
  final DatabaseService _databaseService = DatabaseService();
  late Board board1;
  late Board board2;

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushNamed(context, MainMenuScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    initializeBoards();
    if (!widget.isTurn) {
      _databaseService
          .listenForCoordinates(widget.roomId)
          .listen((coordinates) {
        if (coordinates.isNotEmpty) {
          // Check if coordinates list is not empty
          setState(() {
            dropBomb(coordinates);
          });
        }
      });
    }
  }

  dropBomb(List<int> coords) {
    board1.cells[coords[0]][coords[1]].status = SquareStatus.hit;
  }

  void initializeBoards() {
    board1 = Board();
    board2 = Board();
    board1.placeShipRandomly();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battleship Game',
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Your Board',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: BoardWidget(
                        board: board1,
                        visibleShips: true,
                        roomId: widget.roomId,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Opponent\'s Board',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: false,
                      child: BoardWidget(
                        board: board2,
                        visibleShips: false,
                        roomId: widget.roomId,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoardWidget extends StatelessWidget {
  late Board board;
  final bool visibleShips;
  final String roomId;

  BoardWidget({
    super.key,
    required this.visibleShips,
    required this.board,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        10,
        (index) => Row(
          children: List.generate(
            10,
            (index2) => SquareWidget(
              square: board.cells[index][index2],
              row: index,
              col: index2,
              visibleShips: visibleShips,
              roomId: roomId,
            ),
          ),
        ),
      ),
    );
  }
}

class SquareWidget extends StatefulWidget {
  final Square square;
  final bool visibleShips;
  final int row;
  final int col;
  final String roomId;

  final DatabaseService _databaseService = DatabaseService();

  SquareWidget({
    Key? key,
    required this.square,
    required this.visibleShips,
    required this.row,
    required this.col,
    required this.roomId,
  }) : super(key: key);

  void sendCoordinates(int row, int column) async {
    _databaseService.sendCoordinates(roomId, row, column);
  }

  @override
  _SquareWidgetState createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.sendCoordinates(widget.row, widget.col);
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: determineColour(widget.square),
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }

  Color determineColour(Square square) {
    switch (square.status) {
      case SquareStatus.empty:
        return Colors.grey;
      case SquareStatus.ship:
        return widget.visibleShips ? Colors.green : Colors.grey;
      case SquareStatus.hit:
        return Colors.orange;
      case SquareStatus.miss:
        return Colors.blue;
      case SquareStatus.sunk:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
