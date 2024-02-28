import 'package:new_tictacto/game/ship.dart';

enum SquareStatus { empty, ship, hit, miss, sunk }

class Square {
  Ship? ship;
  SquareStatus status = SquareStatus.empty;
}
