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
      'player1': room.player1,
      'player2': null,
    });
    return roomId;
  }

  Future<void> sendCoordinates(String roomId, int row, int column) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('data')
          .doc('coordinates')
          .set(
              {
            'row': row,
            'column': column,
            'timestamp': FieldValue.serverTimestamp(),
          },
              SetOptions(
                  merge:
                      true)); // Use merge option to merge with existing document if it exists
    } catch (e) {
      // Handle any errors that occur during the update process
      print('Error sending coordinates: $e');
      throw e; // Rethrow the error for handling at the caller level if necessary
    }
  }

  Stream<List<int>> listenForCoordinates(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('data')
        .doc('coordinates')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null &&
            data.containsKey('row') &&
            data.containsKey('column')) {
          final int row = data['row'];
          final int column = data['column'];
          return [row, column];
        }
      }
      return [];
    });
  }

  Future<void> sendResponse(String roomId, bool response) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('data')
          .doc('response')
          .set({
        'isHit': response,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle any errors that occur during the update process
      print('Error sending response: $e');
      throw e; // Rethrow the error for handling at the caller level if necessary
    }
  }

  Stream<bool?> listenForResponse(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('data')
        .doc('response')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey('isHit')) {
          return data['isHit'];
        }
      }
      return null; // Return false if the document doesn't exist or 'isHit' is not present
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
        print('error1');
        return null; // Room is already full
      }
    } else {
      print('error2');
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
