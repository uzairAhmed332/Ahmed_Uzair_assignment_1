import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'character.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class Character {
  @HiveField(0)
  String name;

  @HiveField(1)
  String gender;

  @HiveField(2)
  List<String> aliases;

  Character({
    required this.name,
    required this.gender,
    required this.aliases,
  });

  // factory Character.fromJson(Map<String, dynamic> json) {
  //   return Character(
  //       name: json['name'],
  //       gender: json['gender'],
  //       aliases: json['aliases']
  //   );
  // }

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
