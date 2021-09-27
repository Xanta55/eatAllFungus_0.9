import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'mapTile.freezed.dart';

// *.g.dart is needed for fromJson/toJson
part 'mapTile.g.dart';

@freezed
class MapTile with _$MapTile {
  const MapTile._();
  const factory MapTile({
    required String description,
    required List<String> inventory,
    required int timesDug,
    required int sporeLevel,
    required int buffShrooms,
    required List<String> visibleFor,
    required int xCoord,
    required int yCoord,
    String? id,
  }) = _MapTile;

  factory MapTile.fromJson(Map<String, dynamic> json) =>
      _$MapTileFromJson(json);

  factory MapTile.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data != null) {
      return MapTile.fromJson(data).copyWith(id: doc.id);
    } else {
      return MapTile(
        description: '',
        inventory: [],
        timesDug: 0,
        buffShrooms: 0,
        sporeLevel: 0,
        visibleFor: [],
        xCoord: 0,
        yCoord: 0,
      );
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
