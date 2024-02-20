import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_tictacto/models/player.dart';
import 'package:new_tictacto/models/room.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom(Room room, Player player) async {
    String roomId = _generateRoomCode();
    await _firestore.collection('rooms').doc(roomId).set({
      'currentRound': room.currentRound,
      'isFull': room.isFull,
      'maxRounds': room.maxRounds,
      'turnIndex': room.turnIndex,
      'player1': player.toMap(),
      'player2': null,
    });
    return roomId;
  }

  Future<String?> joinRoom(String roomId, Player player) async {
    DocumentSnapshot roomSnapshot =
        await _firestore.collection('rooms').doc(roomId).get();

    if (roomSnapshot.exists) {
      Room room = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
      if (room.player2 == null) {
        await _firestore.collection('rooms').doc(roomId).update({
          'player2': player.toMap(),
          'isFull': true,
        });
        return roomId;
      } else {
        return null; // Room is already full
      }
    } else {
      return null; // Room not found
    }
  }

  Stream<bool> roomStatusStream(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) => snapshot.get('isFull') ?? false);
  }

  String _generateRoomCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
