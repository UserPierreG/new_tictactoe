// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:new_tictacto/game/ship.dart';
import 'package:new_tictacto/game/square.dart';

class Board {
  late int rows;
  late int cols;
  late List<List<Square>> cells;
  late int shipsLeft;
  late List<Ship> ships;

  Board() {
    rows = 10;
    cols = 10;
    cells = List.generate(rows, (_) => List.generate(cols, (_) => Square()));
    ships = [
      Ship('Carrier', 5),
      Ship('Battleship', 4),
      Ship('Submarine', 3),
      Ship('Destroyer', 2)
    ];
    shipsLeft = ships.length;
  }

  bool isValidCoordinate(int row, int col) {
    return row >= 0 && row < cells.length && col >= 0 && col < cells[0].length;
  }

  bool isValidPlacement(int row, int col, int size, bool horizontal) {
    if (horizontal) {
      if (col + size > cells[0].length) return false;
      for (int i = 0; i < size; i++) {
        if (!isValidCoordinate(row, col + i) ||
            cells[row][col + i].status != SquareStatus.empty) {
          return false;
        }
        // Check if adjacent cells are empty
        if (col + i - 1 >= 0 &&
            cells[row][col + i - 1].status != SquareStatus.empty) {
          return false;
        }
        if (col + i + 1 < cells[0].length &&
            cells[row][col + i + 1].status != SquareStatus.empty) {
          return false;
        }
      }
    } else {
      if (row + size > cells.length) return false;
      for (int i = 0; i < size; i++) {
        if (!isValidCoordinate(row + i, col) ||
            cells[row + i][col].status != SquareStatus.empty) {
          return false;
        }
        // Check if adjacent cells are empty
        if (row + i - 1 >= 0 &&
            cells[row + i - 1][col].status != SquareStatus.empty) {
          return false;
        }
        if (row + i + 1 < cells.length &&
            cells[row + i + 1][col].status != SquareStatus.empty) {
          return false;
        }
      }
    }
    return true;
  }

  void placeShipRandomly() {
    final random = Random();
    for (var ship in ships) {
      bool placed = false;
      while (!placed) {
        final row = random.nextInt(cells.length);
        final col = random.nextInt(cells[0].length);
        final horizontal = random.nextBool();
        if (isValidPlacement(row, col, ship.size, horizontal)) {
          if (horizontal) {
            for (int i = 0; i < ship.size; i++) {
              cells[row][col + i].status = SquareStatus.ship;
              cells[row][col + i].ship = ship;
              ship.addPosition(cells[row][col + i]);
            }
          } else {
            for (int i = 0; i < ship.size; i++) {
              cells[row + i][col].status = SquareStatus.ship;
              cells[row + i][col].ship = ship;
              ship.addPosition(cells[row + i][col]);
            }
          }
          placed = true;
        }
      }
    }
  }

  void displayBoard(bool isCPU) {
    print('$shipsLeft ships left.');
    for (int i = 0; i < rows; i++) {
      stdout.write(String.fromCharCode(i + 65));
      for (int j = 0; j < cols; j++) {
        switch (cells[i][j].status) {
          case SquareStatus.empty:
            stdout.write('∼');
          case SquareStatus.ship:
            if (isCPU == true) {
              stdout.write('∼');
            } else {
              stdout.write(cells[i][j].ship!.code);
            }
          case SquareStatus.hit:
            stdout.write('*');
          case SquareStatus.miss:
            stdout.write('\'');
          case SquareStatus.sunk:
            stdout.write('X');
          default:
            stdout.write('?');
        }
      }
      print("");
    }
    stdout.write(' ');
    for (int i = 0; i < cols; i++) {
      stdout.write(i);
    }
    print("");
    print("");
  }

  SquareStatus bombSquare(int row, int col) {
    if (!isValidCoordinate(row, col)) {
      return SquareStatus.empty;
    }
    return cells[row][col].status;
  }
}
