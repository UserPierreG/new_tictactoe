// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/player.dart';
import 'package:new_tictacto/game/square.dart';

void main() {
  runApp(BattleshipApp());
}

class BattleshipApp extends StatelessWidget {
  static String routeName = '/board2-page';
  late Game game;

  bool notPlay = false;

  BattleshipApp({Key? key}) : super(key: key) {
    game = Game();
    game.start();
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
              const SizedBox(height: 60),
              const Text(
                'Your Board',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: BoardWidget(
                        board: game.player1.board,
                        visibleShips: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Computer\'s Board',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: notPlay,
                      child: BoardWidget(
                        board: game.player1.board,
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

class SquareWidget extends StatefulWidget {
  final Square square;
  final bool visibleShips;

  const SquareWidget({
    Key? key,
    required this.square,
    required this.visibleShips,
  }) : super(key: key);

  @override
  _SquareWidgetState createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String message;
        if (widget.square.status == SquareStatus.miss ||
            widget.square.status == SquareStatus.hit ||
            widget.square.status == SquareStatus.sunk) {
          message = 'Already Played This Square. Try Again!';
        } else if (widget.square.status == SquareStatus.ship) {
          message = 'Hit!';
          widget.square.status = SquareStatus.hit;
          widget.square.ship!.size--;
          if (widget.square.ship!.isSunk()) {
            reloadSunkShip(widget.square.ship!.ship);
            message = 'Ship ' + widget.square.ship!.name + ' Sunk!';
          }
        } else {
          message = 'Miss!';
          widget.square.status = SquareStatus.miss;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: determineColour(widget.square),
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }

  void reloadSunkShip(List<Square>? ship) {
    for (var square in ship!) {
      square.status = SquareStatus.sunk;
    }
  }

  Color determineColour(Square square) {
    switch (square.status) {
      case SquareStatus.empty:
        return Colors.grey;
      case SquareStatus.ship:
        if (widget.visibleShips) {
          return Colors.green;
        } else {
          return Colors.grey;
        }
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

class BoardWidget extends StatelessWidget {
  final Board board;
  final bool visibleShips;

  const BoardWidget({
    Key? key,
    required this.board,
    required this.visibleShips,
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
              visibleShips: visibleShips,
            ),
          ),
        ),
      ),
    );
  }
}

class Game {
  late Player player1;
  late Player player2;

  void start() {
    player1 = Player('John', Board(), false);
    player2 = Player('Robot', Board(), true);
    player1.placeShipsRandomly();
    player2.placeShipsRandomly();
    print("${player1.name}'s turn!");
  }
}
