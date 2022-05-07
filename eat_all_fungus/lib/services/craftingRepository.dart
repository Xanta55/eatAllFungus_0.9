import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/craftingRecipe.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseCraftingRepository {
  Future<List<Recipe>> getRecipes();
}

final craftingRepository =
    Provider<CraftingRepository>((ref) => CraftingRepository(ref.read));

class CraftingRepository implements BaseCraftingRepository {
  final Reader _read;
  const CraftingRepository(this._read);

  @override
  Future<List<Recipe>> getRecipes() async {
    try {
      // Reading the Realtime Database
      final snapshot = await _read(realtimeDatabaseProvider)
          .reference()
          .child('itemRecipes')
          .once();

      if (snapshot.exists) {
        // Checking, if snap exists
        final recipesMap = new Map<String, dynamic>.from(snapshot.value);

        //Transform into a list
        final recipesList = recipesMap.entries.map((e) {
          final innerMap = new Map<String, dynamic>.from(e.value);

          // Putting it all together
          return Recipe(
            title: e.key,
            input: Map<String, int>.from(innerMap['input']),
            output: Map<String, int>.from(innerMap['output']),
          );
        }).toList();
        return recipesList;
      } else {
        print('ohno, no recipes yet...');
        return [];
      }
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
