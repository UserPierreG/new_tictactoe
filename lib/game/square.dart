// ignore_for_file: avoid_print

import 'package:new_tictacto/game/ship.dart';

enum SquareStatus { empty, ship, hit, miss, sunk }

class Square {
  Ship? ship;
  late SquareStatus status;

  Square() {
    status = SquareStatus.empty;
  }

  void setShip(Ship ship) {
    this.ship = ship;
    status = SquareStatus.ship;
  }

  bool bombSquare() {
    switch (status) {
      case SquareStatus.empty:
        status = SquareStatus.miss;
        print("Miss!");
        return true;
      case SquareStatus.ship:
        ship!.hitShip();
        if (ship!.isSunk()) {
          status = SquareStatus.sunk;
          print("${ship!.name} sunk!");
        } else {
          status = SquareStatus.hit;
          print("Hit!");
        }
        return true;
      case SquareStatus.hit:
      case SquareStatus.miss:
      case SquareStatus.sunk:
        print("Already played this square. Try Again.");
        return false;
    }
  }
}
