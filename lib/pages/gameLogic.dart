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
  late bool blockStream;
  late bool responseStream;
  int? row;
  int? col;

  GameLogic({
    required this.turn,
    required this.player,
    required this.roomId,
  }) {
    blockStream = turn;
    responseStream = turn;
    _printStreamStatus();
    initialise();
  }

  void _printStreamStatus() {
    print('Stream is ${blockStream ? 'blocked' : 'NOT blocked'}');
  }

  bool isTurn() => turn;

  void initialise() {
    board1 = Board();
    board2 = Board();
    board1.placeShipRandomly();
    _printInitialMessage();
    startListening();
    startListeningToResponse();
    print('Subscribed');
  }

  void _printInitialMessage() {
    final action = isTurn() ? 'created the room' : 'joined';
    print(
        '$player $action, ${isTurn() ? 'getting ready to send coords' : 'started listening for coords'}');
  }

  void startListeningToResponse() {
    _databaseService.listenForResponse(roomId).listen((response) {
      if (response != null && responseStream) {
        responseStream = false;
        if (response == 'hit') {
          print("received: $response hit");
          board2.cells[row!][col!].status = SquareStatus.hit;
        } else {
          print("received: $response miss");
          board2.cells[row!][col!].status = SquareStatus.miss;
        }
      }
    });
  }

  void startListening() {
    _databaseService.listenForCoordinates(roomId).listen((coordinates) {
      if (coordinates.isNotEmpty && !blockStream) {
        blockStream = true;
        print('Stream blocked');
        dropBomb(coordinates);
        Future.delayed(Duration(milliseconds: 500), () {
          print('paused .5 sec before you can play');
          responseStream = true;
          changeTurn();
        });
      }
    });
  }

  void changeTurn() {
    print('Changing turn');
    turn = !turn;
  }

  void dropBomb(List<int> coords) {
    print('Dropping bomb');
    SquareStatus status = board1.cells[coords[0]][coords[1]].status;

    if (status == SquareStatus.empty) {
      board1.cells[coords[0]][coords[1]].status = SquareStatus.miss;
      print('sent MISS');
      _databaseService.sendResponse(roomId, 'miss');
    } else if (status == SquareStatus.ship) {
      board1.cells[coords[0]][coords[1]].status = SquareStatus.hit;
      print('sent HIT');
      _databaseService.sendResponse(roomId, 'hit');
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
  }

  void sendCoordinates(int row, int column) {
    if (isTurn()) {
      this.row = row;
      this.col = column;
      _databaseService.sendCoordinates(roomId, row, column);
      changeTurn();
      print('Sending coords');
      _unblockStreamAfterDelay();
    }
  }

  void _unblockStreamAfterDelay() {
    Future.delayed(Duration(milliseconds: 5000), () {
      print('Stream unblocked after .5 seconds');
      blockStream = false;
    });
  }
}
