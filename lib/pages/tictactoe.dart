import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<Color> board;
  late Color currentPlayer;
  late bool gameOver;
  late bool isPlayerTurn;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    board = List.filled(9, Colors.white);
    currentPlayer = Colors.red;
    gameOver = false;
    isPlayerTurn = true; // Player starts first
    setState(() {});
  }

  void playMove(int index) {
    if (!gameOver && board[index] == Colors.white && isPlayerTurn) {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner(currentPlayer)) {
          gameOver = true;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Game Over"),
              content: Text(
                  "Player ${currentPlayer == Colors.red ? 'Red' : 'Blue'} wins!"),
              actions: [
                TextButton(
                  child: Text("Play Again"),
                  onPressed: () {
                    Navigator.pop(context);
                    startGame();
                  },
                ),
              ],
            ),
          );
        } else if (board.every((element) => element != Colors.white)) {
          gameOver = true;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Game Over"),
              content: Text("It's a draw!"),
              actions: [
                TextButton(
                  child: Text("Play Again"),
                  onPressed: () {
                    Navigator.pop(context);
                    startGame();
                  },
                ),
              ],
            ),
          );
        } else {
          currentPlayer =
              currentPlayer == Colors.red ? Colors.blue : Colors.red;
        }
      });

      // Computer's turn
      Timer(Duration(seconds: 1), () {
        if (!gameOver && !isPlayerTurn) {
          int computerMove = _getRandomEmptySquare();
          setState(() {
            board[computerMove] = Colors.blue; // Computer's move color is blue
            if (checkWinner(Colors.blue)) {
              gameOver = true;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Game Over"),
                  content: Text("Computer wins!"),
                  actions: [
                    TextButton(
                      child: Text("Play Again"),
                      onPressed: () {
                        Navigator.pop(context);
                        startGame();
                      },
                    ),
                  ],
                ),
              );
            } else if (board.every((element) => element != Colors.white)) {
              gameOver = true;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Game Over"),
                  content: Text("It's a draw!"),
                  actions: [
                    TextButton(
                      child: Text("Play Again"),
                      onPressed: () {
                        Navigator.pop(context);
                        startGame();
                      },
                    ),
                  ],
                ),
              );
            } else {
              currentPlayer =
                  currentPlayer == Colors.red ? Colors.blue : Colors.red;
              isPlayerTurn = true;
            }
          });
        }
      });

      isPlayerTurn = false; // Disable player's turn until computer's move
    }
  }

  bool checkWinner(Color player) {
    List<List<int>> winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var condition in winningConditions) {
      if (board[condition[0]] == player &&
          board[condition[1]] == player &&
          board[condition[2]] == player) {
        return true;
      }
    }
    return false;
  }

  int _getRandomEmptySquare() {
    List<int> emptySquares = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == Colors.white) {
        emptySquares.add(i);
      }
    }
    return emptySquares.isNotEmpty
        ? emptySquares[Random().nextInt(emptySquares.length)]
        : -1; // No empty square available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        color: Colors.black, // Set background color to black
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                playMove(index);
              },
              child: Container(
                color: board[index],
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
