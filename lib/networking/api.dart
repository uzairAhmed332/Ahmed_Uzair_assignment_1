// The class is responsible to load the GoT characters from the GoTAPI (on https://anapioficeandfire.com/)
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:ue1_basisprojekt/db/character.dart';
import 'package:http/http.dart' as http;

class API {
  static int count = 1;

  int pageNumber = 1;
  int lastPage = 0;

  List<Character> _characters = [];

  // Loads the list of GoT characters
  //Async method always return future
  Future<List<Character>> fetchRemoteGoTCharacters() async {

    String _charactersRoute = "https://www.anapioficeandfire.com/api/characters?page=$pageNumber&pageSize=50";

    if (pageNumber <= lastPage || lastPage == 0) {
      var url = Uri.parse(_charactersRoute);
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Page Number: $pageNumber');

      if (lastPage == 0) lastPage = _extractLastPageNumber(response);

      List list = jsonDecode(response.body);
      list.forEach((e) {
        var character = Character.fromJson(e);
        if (character.name.isNotEmpty &&
            character.gender.isNotEmpty &&
            character.aliases.first.isNotEmpty) {
          var duplicate = _characters.firstWhere(
                  (element) => element.name == character.name,
              orElse: () => Character(name: "", gender: "", aliases: []));
          if (duplicate.name.isNotEmpty) {
            var index = _characters.indexOf(duplicate);
            _characters[index].aliases.addAll(character.aliases);
          } else {
            _characters.add(character);
          }
        }
      });
    }
    pageNumber++;
    return _characters;
  }

  int _extractLastPageNumber(http.Response response) {
    String pageCount = response.headers['link']!.split(',').last;
    const start = "page=";
    const end = "&";

    final startIndex = pageCount.indexOf(start);
    final endIndex = pageCount.indexOf(end, startIndex + start.length);

    String pageNumber =
    pageCount.substring(startIndex + start.length, endIndex);

    print(pageNumber);

    return int.parse(pageNumber);
  }
}
