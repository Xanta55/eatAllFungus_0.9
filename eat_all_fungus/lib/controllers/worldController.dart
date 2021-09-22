import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final worldExceptionProvider = StateProvider<CustomException?>((_) => null);

final worldControllerProvider =
    StateNotifierProvider<WorldController, AsyncValue<World>>((ref) {
  // Here the Controller gets the userID!
  final profile = ref.watch(profileControllerProvider);
  print('${profile.data?.value.currentWorld}');
  return WorldController(ref.read, profile.data?.value.currentWorld);
});

class WorldController extends StateNotifier<AsyncValue<World>> {
  final Reader _read;
  final String? _worldID;

  WorldController(this._read, this._worldID) : super(AsyncValue.loading()) {
    if (_worldID != null) {
      getWorld();
    }
  }

  Future<void> getWorld({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final world = await _read(worldRepository).getWorld(id: _worldID ?? '');
      if (mounted) {
        state = AsyncValue.data(world);
      }
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> insertPlayer({required String playerID}) async {
    try {
      await getWorld();
      await _read(worldRepository).updateWorld(
          id: _worldID!,
          worldInput: state.data!.value
              .copyWith(currentPlayers: state.data!.value.currentPlayers + 1));
      state.whenData((value) => value);
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }

  Future<void> updateWorld({required World updatedWorld}) async {
    try {
      await _read(worldRepository)
          .updateWorld(id: _worldID!, worldInput: updatedWorld);
      state.whenData(
          (value) => value.id == updatedWorld.id ? updatedWorld : value);
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }

  Future<void> deleteWorld({required String worldId}) async {
    try {
      await _read(worldRepository).deleteWorld(id: worldId);
      state.whenData((value) => AsyncValue.data(value));
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }
}
