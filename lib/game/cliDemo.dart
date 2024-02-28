// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/player.dart';
import 'package:new_tictacto/game/square.dart';

void main() {
  Player player1 = Player("Jimmy", Board(), false);
  Player player2 = Player("CPU", Board(), true);

  player1.placeShipsRandomly();
  player2.placeShipsRandomly();

  while (true) {
    print('${player1.name}, it\'s your turn!');
    player2.displayBoard();
    print('Enter target coordinates (row column):');
    final targetRow = int.parse(stdin.readLineSync()!) - 1;
    final targetCol = int.parse(stdin.readLineSync()!) - 1;
    final result = player2.board.bombSquare(targetRow, targetCol);
    if (result == SquareStatus.ship) {
      print('Hit!');
      player2.board.cells[targetRow][targetCol].status = SquareStatus.hit;
      player2.board.cells[targetRow][targetCol].ship!.size--;
      if (player2.board.cells[targetRow][targetCol].ship!.isSunk()) {
        player2.board.shipsLeft--;
      }
    } else {
      print('Miss!');
      player2.board.cells[targetRow][targetCol].status = SquareStatus.miss;
    }
    if (player2.board.shipsLeft == 0) {
      print('${player1.name} wins!');
      break;
    }
  }
}
