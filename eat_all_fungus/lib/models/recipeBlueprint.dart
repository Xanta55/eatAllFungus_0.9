import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recipeBlueprint.freezed.dart';
part 'recipeBlueprint.g.dart';

@freezed
class RecipeBlueprint with _$RecipeBlueprint {
  const RecipeBlueprint._();

  const factory RecipeBlueprint({
    required Map<String, int> needsToComplete,
    required String description,
    required String onTap,
    String? id,
  }) = _RecipeBlueprint;

  factory RecipeBlueprint.fromJson(Map<String, dynamic> json) =>
      _$RecipeBlueprintFromJson(json);

  factory RecipeBlueprint.fromDocument(
      DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc?.data();
    if (data != null) {
      return RecipeBlueprint.fromJson(data).copyWith(id: doc?.id);
    } else {
      return RecipeBlueprint(
          needsToComplete: {'error': 1}, description: '', onTap: 'printError');
    }
  }

  Map<String, dynamic> toDocumentNoID() => toJson()..remove('id');
  Map<String, dynamic> toDocument() => toJson();
}
