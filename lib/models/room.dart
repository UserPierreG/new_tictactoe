// ignore_for_file: file_names

import 'package:new_tictacto/models/player.dart';

class Room {
  int currentRound;
  bool isFull;
  int maxRounds;
  int turnIndex;
  Player player1;
  Player? player2;

  Room({
    this.currentRound = 1, // default value for currentRound
    this.isFull = false, // default value for isFull
    this.maxRounds = 6, // default value for maxRounds
    this.turnIndex = 0, // default value for turnIndex
    required this.player1,
    this.player2,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentRound': currentRound,
      'isFull': isFull,
      'maxRounds': maxRounds,
      'turnIndex': turnIndex,
      'player1': player1.toMap(),
      'player2': player2?.toMap(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      currentRound: map['currentRound'],
      isFull: map['isFull'],
      maxRounds: map['maxRounds'],
      turnIndex: map['turnIndex'],
      player1: Player.fromMap(map['player1']),
      player2: map['player2'] != null ? Player.fromMap(map['player2']) : null,
    );
  }
}
