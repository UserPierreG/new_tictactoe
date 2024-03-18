import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({Key? key}) : super(key: key);

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late GameLogic game;

  @override
  void initState() {
    super.initState();
    game = GameLogic();
  }

  void updateGame() {
    setState(() {
      // State is updated here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GameBoard(game: game, updateGame: updateGame),
            const SizedBox(height: 20.0),
            GameStatus(game: game),
            const SizedBox(height: 20.0),
            ResetButton(game: game, updateGame: updateGame),
          ],
        ),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key, required this.game, required this.updateGame})
      : super(key: key);

  final GameLogic game;
  final Function updateGame;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            game.playMove(index);
            updateGame(); // Call the callback to trigger state update
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: Text(
                game.board[index],
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key, required this.game}) : super(key: key);

  final GameLogic game;

  @override
  Widget build(BuildContext context) {
    return Text(
      game.gameStatus,
      style: const TextStyle(fontSize: 20.0),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key, required this.game, required this.updateGame})
      : super(key: key);

  final GameLogic game;
  final Function updateGame;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        game.resetGame();
        updateGame(); // Call the callback to trigger state update
      },
      child: const Text('Reset Game'),
    );
  }
}

class GameLogic {
  late List<String> board;
  late String currentPlayer;
  late String gameStatus;

  GameLogic() {
    board = List.filled(9, "");
    currentPlayer = 'X';
    gameStatus = '';
  }

  void playMove(int index) {
    if (board[index] == "" && gameStatus.isEmpty) {
      board[index] = currentPlayer;
      if (_checkWin(currentPlayer)) {
        gameStatus = '$currentPlayer wins!';
      } else if (!board.contains("")) {
        gameStatus = 'Draw!';
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    }
  }

  bool _checkWin(String player) {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == player &&
          board[i + 1] == player &&
          board[i + 2] == player) {
        return true;
      }
    }
    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] == player &&
          board[i + 3] == player &&
          board[i + 6] == player) {
        return true;
      }
    }
    // Check diagonals
    if ((board[0] == player && board[4] == player && board[8] == player) ||
        (board[2] == player && board[4] == player && board[6] == player)) {
      return true;
    }
    return false;
  }

  void resetGame() {
    board = List.filled(9, "");
    currentPlayer = 'X';
    gameStatus = '';
  }
}
