import 'package:flutter/material.dart';
import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/square.dart';
import 'package:new_tictacto/pages/gameLogic.dart';

class MultiplayerApp extends StatefulWidget {
  static String routeName = '/multiplayer-page';
  final String roomId;
  final bool isTurn;
  final String player;

  const MultiplayerApp({
    Key? key,
    required this.roomId,
    required this.isTurn,
    required this.player,
  }) : super(key: key);

  @override
  State<MultiplayerApp> createState() => _MultiplayerAppState();
}

class _MultiplayerAppState extends State<MultiplayerApp> {
  late GameLogic game;

  void refreshState() {
    setState(() {}); // Trigger UI update after CPU move
  }

  @override
  void initState() {
    super.initState();
    print("INITIALISE");
    game = GameLogic(
        turn: widget.isTurn,
        player: widget.player,
        roomId: widget.roomId,
        onUpdateGameState: refreshState);
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
                        game: game,
                        board: game.board1,
                        visibleShips: true,
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
                        game: game,
                        board: game.board2,
                        visibleShips: false,
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
  final Board board;
  final bool visibleShips;
  final GameLogic game;

  const BoardWidget({
    Key? key,
    required this.visibleShips,
    required this.board,
    required this.game,
  }) : super(key: key);

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
              game: game,
            ),
          ),
        ),
      ),
    );
  }
}

class SquareWidget extends StatelessWidget {
  final Square square;
  final bool visibleShips;
  final int row;
  final int col;
  final GameLogic game;

  const SquareWidget({
    Key? key,
    required this.square,
    required this.visibleShips,
    required this.row,
    required this.col,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        game.sendCoordinates(row, col);
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: determineColour(square),
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
        return visibleShips ? Colors.green : Colors.grey;
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
