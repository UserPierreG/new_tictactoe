import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final bool isFull;
  final String player1;
  final String? player2;

  Room({
    this.isFull = false,
    required this.player1,
    this.player2,
  });

  Map<String, dynamic> toMap() {
    return {
      'isFull': isFull,
      'player1': player1,
      'player2': player2,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      isFull: map['isFull'] as bool,
      player1: map['player1'] as String,
      player2: map['player2'] as String?,
    );
  }
}
