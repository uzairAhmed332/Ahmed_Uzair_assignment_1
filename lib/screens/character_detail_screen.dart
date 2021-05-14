import 'package:flutter/material.dart';
import 'package:ue1_basisprojekt/db/character.dart';

class CharacterDetailScreen extends StatelessWidget {
final Character character;

const CharacterDetailScreen({
Key? key,
required this.character ,
}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.red.shade700,
      title: Text(character.name),
      centerTitle: true,
      elevation: 0,
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            _buildTextRow('Gender', character.gender),
            SizedBox(height: 20),
            Divider(
                color: Colors.white
            ),
            SizedBox(height: 20),
            _buildTextRow('Aliases', character.aliases.join(', '))
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextRow(String key, String value) {
  return Row(
    children: [
      Text(
        key,
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          value,
          style: TextStyle(color: Colors.white,fontSize: 14),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.end,
        ),
      ),
    ],
  );
}
}
