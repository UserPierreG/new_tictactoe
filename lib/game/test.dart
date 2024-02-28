import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: TicTacToeGame(),
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late Player player1;
  late Player player2;
  late Board board1;
  late Board board2;

  @override
  void initState() {
    super.initState();
    player1 = Player('Player 1', 'X');
    player2 = Player('Player 2', 'O');
    board1 = Board();
    board2 = Board();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Turn: ${board1.currentPlayer.name}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BoardWidget(board: board1),
              BoardWidget(board: board2),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                board1.clearBoard();
                board2.clearBoard();
              });
            },
            child: Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}

class Player {
  String name;
  String symbol;

  Player(this.name, this.symbol);
}

class Board {
  late List<String> squares;
  late Player currentPlayer;
  late Player player1; // Initialize player1
  late Player player2; // Initialize player2

  Board() {
    squares = List.filled(9, '');
    player1 = Player('Player 1', 'X'); // Initialize player1
    player2 = Player('Player 2', 'O'); // Initialize player2
    currentPlayer = player1;
  }

  bool checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (squares[i * 3] != '' &&
          squares[i * 3] == squares[i * 3 + 1] &&
          squares[i * 3] == squares[i * 3 + 2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (squares[i] != '' &&
          squares[i] == squares[i + 3] &&
          squares[i] == squares[i + 6]) {
        return true;
      }
    }

    // Check diagonals
    if (squares[0] != '' &&
        squares[0] == squares[4] &&
        squares[0] == squares[8]) {
      return true;
    }
    if (squares[2] != '' &&
        squares[2] == squares[4] &&
        squares[2] == squares[6]) {
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    return squares.every((square) => square != '');
  }

  bool isGameOver() {
    return checkWinner() || isBoardFull();
  }

  void switchPlayer() {
    currentPlayer = currentPlayer == player1 ? player2 : player1;
  }

  void clearBoard() {
    squares = List.filled(9, '');
    currentPlayer = player1;
  }
}

class BoardWidget extends StatelessWidget {
  final Board board;

  BoardWidget({required this.board});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          children: List.generate(3, (col) {
            int index = row * 3 + col;
            return Square(
              index: index,
              player: board.squares[index],
              onTap: () {
                print('Square tapped at index $index');
                if (board.squares[index] == '' && !board.isGameOver()) {
                  board.squares[index] = board.currentPlayer.symbol;
                  if (board.checkWinner()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('${board.currentPlayer.name} wins!'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Restart Game'),
                              onPressed: () {
                                board.clearBoard();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (board.isBoardFull()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Draw!'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Restart Game'),
                              onPressed: () {
                                board.clearBoard();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    board.switchPlayer();
                  }
                }
              },
            );
          }),
        );
      }),
    );
  }
}

class Square extends StatelessWidget {
  final int index;
  final String player;
  final Function onTap;

  Square({required this.index, required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          player,
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
