import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final bool isFull;
  final int turnIndex;
  final String player1;
  final String? player2;
  final String? response;
  final DateTime? timestamp;

  Room({
    this.isFull = false,
    this.turnIndex = 0,
    required this.player1,
    this.timestamp,
    this.player2,
    this.response,
  });

  Map<String, dynamic> toMap() {
    return {
      'isFull': isFull,
      'turnIndex': turnIndex,
      'player1': player1,
      'player2': player2,
      'response': response,
      'timestamp': Timestamp.fromDate(timestamp!),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      timestamp: map['timestamp'].toDate(),
      isFull: map['isFull'] as bool,
      turnIndex: map['turnIndex'] as int,
      player1: map['player1'] as String,
      player2: map['player2'] as String?,
      response: map['response'] as String?,
    );
  }
}
