// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/player.dart';
import 'package:new_tictacto/game/square.dart';
import 'dart:async';
import 'dart:math';

import 'package:new_tictacto/pages/home_page.dart';

class GameLogic {
  late Player player1;
  late Player player2;
  late bool isPlayerTurn;
  late Function onCPUMove; // Callback function to trigger UI update
  late Function onGameOver; // Callback function to handle game over

  GameLogic({required this.onCPUMove, required this.onGameOver}) {
    print('New Game Started');
    player1 = Player("John", Board(), false);
    player2 = Player("CPU", Board(), true);
    player1.board.placeShipRandomly();
    player2.board.placeShipRandomly();
    isPlayerTurn = true;
    printTurn();
  }

  void printTurn() {
    if (isPlayerTurn) {
      print('${player1.name}\'s turn!');
    } else {
      print('${player2.name}\'s turn!');
    }
  }

  bool bombSquare(Square square, Board board) {
    String message;
    if (square.status == SquareStatus.miss ||
        square.status == SquareStatus.hit ||
        square.status == SquareStatus.sunk) {
      message = 'Already Played This Square. Try Again!';
      print(message);
      return true;
    } else if (square.status == SquareStatus.ship) {
      message = 'Hit!';
      square.status = SquareStatus.hit;
      square.ship!.size--;
      if (square.ship!.isSunk()) {
        print('${square.ship!.name} sunk');
        // Change the status of all squares the ship occupies to "sunk"
        for (var s in square.ship!.ship!) {
          s.status = SquareStatus.sunk;
        }
        board.shipsLeft--; // Reduce ship count
        print('${board.shipsLeft} ships left.');
        if (board.shipsLeft == 0) {
          gameOver();
        }
      }
      print(message);
      return false;
    } else {
      message = 'Miss!';
      square.status = SquareStatus.miss;
      print(message);
      return false;
    }
  }

  void gameOver() {
    print('Game Over! All ships sunk.');
    onGameOver(); // Call the callback to handle game over in UI
  }

  void startGame() {
    player1.board = Board(); // Reset player1's board
    player2.board = Board(); // Reset player2's board
    player1.board.placeShipRandomly(); // Place ships randomly for player1
    player2.board.placeShipRandomly(); // Place ships randomly for player2
    isPlayerTurn = true; // Reset turn to player1
    printTurn();
  }

  void playMove(Square square) {
    if (isPlayerTurn) {
      if (bombSquare(square, player2.board)) {
        return;
      }
      isPlayerTurn = false;
      Timer(const Duration(milliseconds: 200), () {
        printTurn();
      });
      Timer(const Duration(milliseconds: 200), () {
        if (!isPlayerTurn) {
          Square randomSquare;
          do {
            int row = Random().nextInt(player1.board.rows);
            int col = Random().nextInt(player1.board.cols);
            randomSquare = player1.board.cells[row][col];
          } while (bombSquare(randomSquare, player1.board));
          onCPUMove();
          isPlayerTurn = true;
          Timer(const Duration(milliseconds: 200), () {
            printTurn();
          });
        }
      });
    }
  }
}

class BattleshipApp extends StatefulWidget {
  static String routeName = '/board2-page';

  const BattleshipApp({super.key});

  @override
  _BattleshipAppState createState() => _BattleshipAppState();
}

class _BattleshipAppState extends State<BattleshipApp> {
  late GameLogic game;

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushNamed(context, MainMenuScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    game = GameLogic(
      onCPUMove: () {
        setState(() {}); // Trigger UI update after CPU move
      },
      onGameOver: () {
        // Show game over dialog
        _showGameOverDialog();
      },
    );
  }

  // Method to show the game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('All ships sunk. What would you like to do?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToHomePage(context);
                // Example: Navigator.pushNamed(context, '/');
              },
              child: Text('Main Menu'),
            ),
            TextButton(
              onPressed: () {
                // Reset the game
                game.startGame();
                // Force a rebuild of the widget tree to update the game board immediately
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
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
                        board: game.player1.board,
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
                        board: game.player2.board,
                        visibleShips: true,
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
  late GameLogic game;
  late Board board;
  final bool visibleShips;

  BoardWidget(
      {super.key,
      required this.visibleShips,
      required this.game,
      required this.board});

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
              game: game,
              visibleShips: visibleShips,
            ),
          ),
        ),
      ),
    );
  }
}

class SquareWidget extends StatefulWidget {
  final Square square;
  final GameLogic game;
  final bool visibleShips;

  const SquareWidget({
    Key? key,
    required this.square,
    required this.game,
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
        setState(() {
          widget.game.playMove(widget.square);
        });
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
