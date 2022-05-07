import 'package:eat_all_fungus/models/craftingRecipe.dart';
import 'package:eat_all_fungus/services/craftingRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final craftingControllerProvider =
    StateNotifierProvider<CraftingController, List<Recipe>>((ref) {
  return CraftingController(ref.read);
});

class CraftingController extends StateNotifier<List<Recipe>> {
  final Reader _read;
  CraftingController(this._read) : super([]) {
    getRecipes();
  }

  Future<void> getRecipes() async {
    state = await _read(craftingRepository).getRecipes();
  }
}
