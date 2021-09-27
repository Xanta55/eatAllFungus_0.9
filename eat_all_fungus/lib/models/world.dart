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
    required bool isOpen,
    List<MapTile>? mapTiles,
    List<News>? news,
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
        mapTiles: [],
        news: [],
        isOpen: false,
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() =>
      toJson()..remove('id')..remove('mapTiles');
  Map<String, dynamic> toDocument() => toJson();
}
