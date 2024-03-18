import 'package:flutter/material.dart';

// Enum to represent the state of a square
enum SquareState { empty, ship, hit, miss }

// Class representing a single square on the game board
class Square {
  SquareState state = SquareState.empty;

  void markAsShip() {
    state = SquareState.ship;
  }

  void markAsHit() {
    state = SquareState.hit;
  }

  void markAsMiss() {
    state = SquareState.miss;
  }
}

// Class representing the game board
class Board {
  final List<List<Square>> grid;

  Board(int size)
      : grid = List.generate(
          size,
          (row) => List.generate(size, (col) => Square()),
        );

  Square getSquare(int row, int col) {
    return grid[row][col];
  }
}

// Class representing a player
class Player {
  final Board opponentBoard;

  Player(this.opponentBoard);

  void bombSquare(int row, int col) {
    Square square = opponentBoard.getSquare(row, col);
    if (square.state == SquareState.ship) {
      square.markAsHit();
    } else {
      square.markAsMiss();
    }
  }
}

// SquareWidget to display a single square on the board
class SquareWidget extends StatelessWidget {
  final Square square;
  final Function(int, int) onSquareTap;
  final int row;
  final int column;
  final double size;

  SquareWidget({
    required this.square,
    required this.row,
    required this.column,
    required this.size,
    required this.onSquareTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = _getColorForSquareState(square.state);

    return GestureDetector(
      onTap: () {
        onSquareTap(row, column);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: color,
        ),
      ),
    );
  }

  Color _getColorForSquareState(SquareState state) {
    switch (state) {
      case SquareState.empty:
        return Colors.blue;
      case SquareState.ship:
        return Colors.grey;
      case SquareState.hit:
        return Colors.red;
      case SquareState.miss:
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }
}

// BoardWidget to display the game board
class BoardWidget extends StatelessWidget {
  final Board board;
  final Function(int, int) onSquareTap;
  final double squareSize;

  BoardWidget({
    required this.board,
    required this.onSquareTap,
    required this.squareSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        board.grid.length,
        (row) => Row(
          children: List.generate(
            board.grid[row].length,
            (col) => SquareWidget(
              square: board.getSquare(row, col),
              row: row,
              column: col,
              size: squareSize,
              onSquareTap: onSquareTap,
            ),
          ),
        ),
      ),
    );
  }
}

// GamePage to display the game
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final int boardSize = 5; // Size of the game board
  final double squareSize = 50.0; // Size of each square in the game board
  late Board playerBoard; // Player's board
  late Player player; // Player instance

  @override
  void initState() {
    super.initState();
    playerBoard = Board(boardSize);
    player = Player(playerBoard);
    // Place some ships on the board (for demonstration purposes)
    _placeShips();
  }

  // Method to place ships on the board (for demonstration purposes)
  void _placeShips() {
    playerBoard.getSquare(0, 0).markAsShip();
    playerBoard.getSquare(1, 1).markAsShip();
    playerBoard.getSquare(2, 2).markAsShip();
  }

  // Method to handle tapping on a square
  void _onSquareTap(int row, int col) {
    // Bomb the square
    player.bombSquare(row, col);
    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battleship Game'),
      ),
      body: Center(
        child: BoardWidget(
          board: playerBoard,
          onSquareTap: _onSquareTap,
          squareSize: squareSize,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GamePage(),
  ));
}
