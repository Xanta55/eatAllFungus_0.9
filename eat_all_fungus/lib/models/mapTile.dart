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
    //required bool isHidden,
    required int xCoord,
    required int yCoord,
    String? id,
  }) = _MapTile;

  factory MapTile.fromJson(Map<String, dynamic> json) =>
      _$MapTileFromJson(json);

  factory MapTile.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MapTile.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
