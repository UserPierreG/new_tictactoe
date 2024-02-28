// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_tictacto/firebase_options.dart';
import 'package:new_tictacto/pages/userInterface.dart';
import 'package:new_tictacto/pages/create_room.dart';
import 'package:new_tictacto/pages/home_page.dart';
import 'package:new_tictacto/pages/join_room.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MainMenuScreen.routeName: (context) => const MainMenuScreen(),
        JoinRoomScreen.routeName: (context) => JoinRoomScreen(),
        CreateRoomScreen.routeName: (context) => CreateRoomScreen(),
        BattleshipApp.routeName: (context) => BattleshipApp(),
      },
      initialRoute: MainMenuScreen.routeName,
    );
  }
}
