import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'town.freezed.dart';
part 'town.g.dart';

@freezed
class Town with _$Town {
  const Town._();
  const factory Town({
    required String name,
    required int xCoord,
    required int yCoord,
    required String worldID,
    required List<String> elders,
    required List<String> requestsToJoin,
    required List<String> members,
    required List<String> buildings,
    required List<String> inventory,
    required List<String> alliances,
    required int wallStrength,
    required int distanceOfSight,
    String? id,
  }) = _Town;

  factory Town.fromJson(Map<String, dynamic> json) => _$TownFromJson(json);

  factory Town.fromDocument(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return Town.fromJson(data).copyWith(id: doc?.id);
    } else {
      return Town(
          name: '',
          worldID: '',
          xCoord: 0,
          yCoord: 0,
          wallStrength: 0,
          alliances: [],
          buildings: [],
          distanceOfSight: 0,
          elders: [],
          inventory: [],
          members: [],
          requestsToJoin: []);
    }
  }
  factory Town.dummyTown() {
    return Town(
        name: '',
        worldID: '',
        xCoord: 0,
        yCoord: 0,
        wallStrength: 0,
        alliances: [],
        buildings: [],
        distanceOfSight: 0,
        elders: [],
        inventory: [],
        members: [],
        requestsToJoin: []);
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
