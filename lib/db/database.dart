import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ue1_basisprojekt/db/character.dart';
import 'package:hive/hive.dart';


//The class shall be responsible to store the GoT characters loaded from the API in a database
class Database {
  late Box<Character> charactersBox;
  List<Character> charactersFiltered = [];

  //The method shall load all stored GoT characters and return them as array
  List<Character> get storedCharacters {
   // charactersFiltered.clear();
    //TODO: Die Charaktere aus einer richtigen Datenbank laden.
    charactersBox = Hive.box<Character>("characters");
    for (int i = 0; i < charactersBox.length; i++) {
     // log('TestData: ${charactersBox.getAt(i)!.name.toString()}');
      charactersFiltered.add(charactersBox.getAt(i)!);
    }
    return charactersFiltered;
  }

  //The method is to store a list of GoT characters in a database
  void save({@required List<Character>? characters}) {
      if (characters != null && characters.isNotEmpty) {
      //TODO: `characters` in einer richtigen Datenbank speichern.

        charactersBox = Hive.box<Character>("characters");
        charactersBox.clear();
        charactersBox.addAll(characters);
    }
  }

}
