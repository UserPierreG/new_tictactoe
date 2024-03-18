import 'package:new_tictacto/game/board.dart';

class Player {
  final String name;
  Board board;
  final bool isCPU;

  Player(this.name, this.board, this.isCPU);

  void displayBoard() {
    print('$name\'s board.');
    board.displayBoard(isCPU);
  }

  void placeShipsRandomly() {
    board.placeShipRandomly();
  }
}
