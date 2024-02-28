import 'package:new_tictacto/game/square.dart';

class Ship {
  String name;
  late String code;
  int size;
  List<Square>? ship;

  Ship(this.name, this.size) {
    code = name[0];
    ship = [];
  }

  addPosition(Square square) {
    ship!.add(square);
  }

  bool isSunk() {
    return size == 0;
  }
}
