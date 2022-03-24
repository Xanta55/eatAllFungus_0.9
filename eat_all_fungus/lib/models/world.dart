import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/news.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'world.freezed.dart';
part 'world.g.dart';

@freezed
class World with _$World {
  const World._();
  const factory World({
    required String name,
    required String description,
    required int currentPlayers,
    required int depth,
    required int daysRunning,
    required bool isOpen,
    int? startAmount,
    List<MapTile>? mapTiles,
    String? id,
  }) = _World;

  factory World.fromJson(Map<String, dynamic> json) => _$WorldFromJson(json);

  factory World.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return World.fromJson(data).copyWith(id: doc?.id).copyWith(mapTiles: []);
      //.copyWith(mapTiles: data['mapTiles']);
    } else {
      return World(
        name: '',
        description: '',
        currentPlayers: 0,
        depth: 1,
        daysRunning: 0,
        mapTiles: [],
        isOpen: false,
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() =>
      toJson()..remove('id')..remove('mapTiles');
  Map<String, dynamic> toDocument() => toJson();
}
