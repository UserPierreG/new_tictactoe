// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:new_tictacto/game/board.dart';
import 'package:new_tictacto/game/square.dart';
import 'package:new_tictacto/services/databaseServices.dart';

class GameLogic {
  late final Board board1;
  late final Board board2;
  final DatabaseService _databaseService = DatabaseService();
  late bool turn;
  late final String player;
  late final String roomId;
  late bool listenToResponse;
  late bool listenToCords;
  late int row;
  late int col;
  Function() onUpdateGameState;

  GameLogic({
    required this.turn,
    required this.player,
    required this.roomId,
    required this.onUpdateGameState,
  }) {
    initialise();
    row = 0;
    col = 0;
  }

  void initialise() {
    board1 = Board();
    board2 = Board();
    board1.placeShipRandomly();
    startListeningToResponse();
    startListeningtoCords();

    if (turn) {
      print('Listen to Cords = false');
      listenToResponse = true;
      print('Listen to Response = true');
      listenToCords = false;
    } else {
      print('Listen to Response = false');
      listenToResponse = false;
      print('Listen to Cords = true');
      listenToCords = true;
    }
  }

  void startListeningToResponse() {
    print('CALLING startListeningToResponse');
    _databaseService.listenForResponse(roomId).listen((response) {
      if (response == null) {
        print("RESPONSE NULL SO IS FILTERED");
      }
      if (response != null && listenToResponse) {
        print('HANDLE $response');
        if (response) {
          print("received: $response, hit");
          board2.cells[row][col].status = SquareStatus.hit;
        } else {
          print("received: $response, miss");
          board2.cells[row][col].status = SquareStatus.miss;
        }
        onUpdateGameState();
        listenToResponse = false;
        print('Listen to Response = false');
        Future.delayed(Duration(milliseconds: 250), () {
          listenToCords = true;
          print('0.5sec pause');
          print('Listen to Cords = true');
        });
      }
    });
  }

  void startListeningtoCords() {
    print('CALLING startListeningtoCords');
    _databaseService.listenForCoordinates(roomId).listen((coordinates) {
      if (coordinates.isNotEmpty && listenToCords) {
        print('received cords: $coordinates');
        dropBomb(coordinates);
        print('Listen to Cords = false');
        listenToCords = false;
        Future.delayed(Duration(milliseconds: 500), () {
          print('1sec pause');
          listenToResponse = true;
          print('Listen to Response = true');
          print('play true');
          turn = true;
          print(' ');
        });
      }
    });
  }

  void dropBomb(List<int> coords) {
    print('Dropping bomb');
    SquareStatus status = board1.cells[coords[0]][coords[1]].status;

    if (status == SquareStatus.empty) {
      board1.cells[coords[0]][coords[1]].status = SquareStatus.miss;
      print('sent MISS');
      sendResponse(roomId, false);
    } else if (status == SquareStatus.ship) {
      board1.cells[coords[0]][coords[1]].status = SquareStatus.hit;
      print('sent HIT');
      sendResponse(roomId, true);
      board1.cells[coords[0]][coords[1]].ship!.size--;
      if (board1.cells[coords[0]][coords[1]].ship!.isSunk()) {
        var ship = board1.cells[coords[0]][coords[1]].ship?.ship;
        print('$ship sunk!');
        if (ship != null) {
          for (var thing in ship) {
            thing.status = SquareStatus.sunk;
          }
        }
      }
    } else {
      print('Already played square; try again!');
    }
    onUpdateGameState();
  }

  void sendResponse(String roomId, bool response) {
    print('CALLING SEND RESPONSE');
    print('sent response: $response');
    _databaseService.sendResponse(roomId, response);
  }

  void sendCords(String roomId, int row, int column) {
    print('CALLING SEND CORDS');
    print('sent cords: [$row, $column]');
    _databaseService.sendCoordinates(roomId, row, column);
  }

  void sendCoordinates(int row, int column) {
    if (turn) {
      this.row = row;
      this.col = column;
      sendCords(roomId, row, column);
      print('play off');
      turn = false;
    }
  }
}
