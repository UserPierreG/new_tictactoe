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
      'coordinates': null,
    });
    return roomId;
  }

  Future<void> sendCoordinates(String roomId, int row, int column) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'coordinates': {'row': row, 'column': column}
    });
    print('sent row: ${row} col: ${column}');
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

  void startListeningToCoordinates(Function(bool?) onHitResult) {
    _firestore.collection('coordinates').snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var document = snapshot.docs.first;
        int? receivedRow = document['row'];
        int? receivedColumn = document['column'];
        // Determine hit or miss based on game logic (e.g., hardcoding hit for demonstration)
        bool isHit = _isHit(receivedRow, receivedColumn);
        // Send the result back to the sender
        _firestore.collection('isHit').add({'isHit': isHit});
        // Pass the hit result to the callback function
        onHitResult(isHit);
      }
    });
  }

  bool _isHit(int? row, int? column) {
    // Implement your game logic here
    // For demonstration, let's assume a hardcoded hit
    return true;
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
