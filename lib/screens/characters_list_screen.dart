import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ue1_basisprojekt/db/character.dart';
import 'package:ue1_basisprojekt/db/database.dart';
import 'package:ue1_basisprojekt/networking/api.dart';
import 'package:ue1_basisprojekt/screens/character_detail_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'character_detail_screen.dart';

class CharactersListScreen extends StatefulWidget {
  @override
  _CharactersListScreenState createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  TextEditingController editingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  late List<Character> characters = [];
  List<Character> charactersFiltered = [];
 // bool firstTime = false;
  bool isLoading = true;
  API _apiInstance = API();

  @override
  void initState() {
    super.initState();

  //  characters.clear();

    if (Database().storedCharacters.isNotEmpty) {
      //Fetch data from DB
      log('Data: from DB');
      isLoading = false;
      characters = Database().storedCharacters;
    } else {
      attachingScrollListioner();
      log('Data: from API');
        _makeApiCall();

    }
  }

  void _makeApiCall() {
    isLoading = true;
    _apiInstance.fetchRemoteGoTCharacters().then((characters) {
      setState(() {
        this.characters.clear();
        // // the setState method re-renders the UI
        // for (Character item in characters) {
        //   if (item.name.isNotEmpty && (item.aliases.isNotEmpty)  ) {
        //     charactersFiltered.add(item);
        //   }
        // }
        charactersFiltered = characters;
        this.characters.addAll(characters);
        Database().save(characters: characters); //Saving in DB
        isLoading = false;
      });
    });
  }

  void attachingScrollListioner() {
    WidgetsBinding.instance!.addPostFrameCallback((_){
      _scrollController.addListener(() {

        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
           log('Data: from api');
            _makeApiCall();

        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        title: Text('Game of Thrones Characters'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    hintText: "Search",
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ),
            Expanded(
              child: MaterialLoader(
                isLoading: isLoading,
                child: RawScrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  thickness: 5,
                  thumbColor: Colors.red.shade700,
                  radius: Radius.circular(20),
                  child: ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      // if (index >= characters.length - 1 && !isLoading) {
                      //   _makeApiCall();
                      //   if (_apiInstance.pageNumber <= _apiInstance.lastPage)
                      //     return MaterialLoader(
                      //       child: Container(),
                      //       padding: 8,
                      //     ).buildLoader(context);
                      // }
                      return _buildCharacterListTile(index);
                    },
                    itemCount: characters.length,
                    separatorBuilder: (_, __) =>
                        Divider(
                          height: 50,
                          thickness: 0.8,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterListTile(int index) {
    final Character character = characters[index];

    return Ink(
      color: Colors.black,
      child: ListTile(
        title: Text(character.name,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        trailing: Icon(
          Icons.arrow_right,
          color: Colors.white,
        ),
        onTap: () {
          //TODO: open the CharacterDetailScreen with the character
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CharacterDetailScreen(character: character)),
          );
        },
      ),
    );
  }



  void filterSearchResults(String query) {
    isLoading = false;
    List<Character> dummySearchList = <Character>[];

    if (Database().storedCharacters.isNotEmpty) {
      //Fetch data from DB
      dummySearchList.addAll(Database().storedCharacters);
      log("DB: ${Database().storedCharacters.toString()}");
    }
    else {
      dummySearchList.addAll(charactersFiltered);
    }

    if (query.isNotEmpty) {
      List<Character> dummyListData = <Character>[];
      dummySearchList.forEach((item) {
        if (item.name.trim().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        characters.clear();
        characters.addAll(dummyListData);
      });
      return;
    }

    else {
      setState(() {
        characters.clear();
        if (Database().storedCharacters.isNotEmpty) {
          //Fetch data from DB
          characters.addAll(Database().storedCharacters);
        }
        else {
          characters.addAll(charactersFiltered);
        }
      });
    }
  }

  @override
  void dispose() {
    Hive.close();
    _scrollController.dispose();
    super.dispose();
  }



}

class MaterialLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color bgColor;
  final double padding;

  final double loaderSize = 24;

  MaterialLoader({
    this.isLoading = false,
    required this.child,
    this.bgColor = Colors.white,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading ? buildLoader(context) : Container(),
      ],
    );
  }

  Padding buildLoader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                boxShadow: [BoxShadow(color: Color(0x26000000))]),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: loaderSize,
                width: loaderSize,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
