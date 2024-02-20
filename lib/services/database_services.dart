// // ignore_for_file: constant_identifier_names

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:new_tictacto/models/room.dart';

// const String ROOM_COLLECTION_REF = "room";

// class RoomDatabaseService {
//   final CollectionReference _roomRef;

//   RoomDatabaseService()
//       : _roomRef = FirebaseFirestore.instance
//             .collection(ROOM_COLLECTION_REF)
//             .withConverter<Room>(
//               fromFirestore: (snapshots, _) => Room.fromJson(
//                 snapshots.data()!,
//               ),
//               toFirestore: (room, _) => room.toJson(),
//             );

//   Stream<QuerySnapshot> getRoom() {
//     return _roomRef.snapshots();
//   }

//   void addRoom(Room room) async {
//     await _roomRef.add(room);
//   }
// }
