import 'package:flutter/material.dart';
import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/square.dart';
import 'package:new_tictacto/gui/squareWidget.dart';

void main() {
  runApp(MaterialApp(
    // Wrap your BoardWidget with MaterialApp
    home: Scaffold(
      // Optionally wrap with Scaffold for basic material design layout
      appBar: AppBar(
        title: Text('Tic Tac Toe Board'),
      ),
      body: BoardWidget(
        board: Board(),
        visibleShips: true,
      ),
    ),
  ));
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
    board.placeShipRandomly();
    return GridView.builder(
      itemCount: board.rows * board.cols,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            board.cols, // Adjust cross axis count based on board.cols
      ),
      itemBuilder: (context, index) {
        int row = index ~/ board.cols; // Calculate row based on board.cols
        int col = index % board.cols; // Calculate col based on board.cols
        return SquareWidget(
          square: board.cells[row][col], // Access cell using getCell method
          visibleShips: visibleShips,
        );
      },
    );
  }
}
