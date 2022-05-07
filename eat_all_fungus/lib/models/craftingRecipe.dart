import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'craftingRecipe.freezed.dart';
part 'craftingRecipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const Recipe._();
  const factory Recipe({
    required String title,
    required Map<String, int> input,
    required Map<String, int> output,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
