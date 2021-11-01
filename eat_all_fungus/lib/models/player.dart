import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const Player._();

  const factory Player({
    required List<String> statusEffects,
    required List<String> inventory,
    required List<String> todoList,
    required int xCoord,
    required int yCoord,
    required String worldID,
    required int inventorySize,
    required int actionPoints,
    required List<String> member,
    String? id,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  factory Player.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return Player.fromJson(data).copyWith(id: doc?.id);
    } else {
      return Player(
        inventory: [],
        statusEffects: [],
        todoList: [],
        worldID: '',
        inventorySize: 0,
        actionPoints: 10,
        member: [],
        xCoord: 0,
        yCoord: 0,
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
