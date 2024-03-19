import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_tictacto/models/room.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom(Room room) async {
    String roomId = _generateRoomCode();
    await _firestore.collection('rooms').doc(roomId).set({
      'isFull': room.isFull,
      'turnIndex': room.turnIndex,
      'player1': room.player1,
      'player2': null,
      'coordinates': null,
      'response': null,
      'timestamp': DateTime.now(), // Include timestamp field with current time
    });
    return roomId;
  }

  Future<void> sendResponse(String roomId, String response) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'response': response,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('send response: ${response}');
  }

  Future<void> sendCoordinates(String roomId, int row, int column) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'coordinates': {'row': row, 'column': column},
      'timestamp': FieldValue.serverTimestamp(), // Add server timestamp
    });
    print('sent row: $row col: $column');
  }

  Stream<List<int>> listenForCoordinates(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        final roomCoordinates = data!['coordinates'];
        if (roomCoordinates != null) {
          return [roomCoordinates['row'], roomCoordinates['column']];
        }
      }
      return [];
    });
  }

  Stream<String?> listenForResponse(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        final response = data!['response'];
        if (response != null) {
          return response;
        }
      }
      return null;
    });
  }

  Future<String?> joinRoom(String roomId, String player) async {
    DocumentSnapshot roomSnapshot =
        await _firestore.collection('rooms').doc(roomId).get();
    if (roomSnapshot.exists) {
      Room room = Room.fromMap(roomSnapshot.data()! as Map<String, dynamic>);
      if (room.player2 == null) {
        await _firestore.collection('rooms').doc(roomId).update({
          'player2': player,
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

  isPlayerTurn(String roomId, String player) {}
}
