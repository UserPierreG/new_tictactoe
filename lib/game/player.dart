import 'package:new_tictacto/game/board.dart';

class Player {
  String name;
  Board board;
  bool isCPU;

  Player(this.name, this.board, this.isCPU);

  void displayBoard() {
    print('$name\'s board.');
    board.displayBoard(isCPU);
  }

  void placeShipsRandomly() {
    board.placeShipRandomly();
  }
}
