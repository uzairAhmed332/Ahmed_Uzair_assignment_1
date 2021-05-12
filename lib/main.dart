import 'package:flutter/material.dart';
import 'package:ue1_basisprojekt/screens/characters_list_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'db/character.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(CharacterAdapter());
  await Hive.openBox<Character>('characters');

  runApp(
    MaterialApp(
      title: 'GoT Characters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CharactersListScreen(),
    ),
  );

}
