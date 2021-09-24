import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final worldListExceptionProvider = StateProvider<CustomException?>((_) => null);

final worldListControllerProvider =
    StateNotifierProvider<WorldListController, AsyncValue<List<World>>>((ref) {
  return WorldListController(ref.read);
});

class WorldListController extends StateNotifier<AsyncValue<List<World>>> {
  final Reader _read;

  WorldListController(this._read) : super(AsyncValue.loading()) {
    getWorlds();
  }

  Future<void> getWorlds({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final worlds = await _read(worldRepository).getAvailableWorlds();
      if (mounted) {
        state = AsyncValue.data(worlds ?? []);
      }
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createEmptyWorld({required World world}) async {
    try {
      await _read(worldRepository).createEmptyWorld(
          name: world.name,
          description: world.description,
          depth: world.depth,
          isOpen: world.isOpen,
          mapTiles: world.mapTiles ?? []);
      getWorlds();
      state.whenData((value) => state = AsyncValue.data(value));
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
