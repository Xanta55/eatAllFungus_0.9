import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final worldExceptionProvider = StateProvider<CustomException?>((_) => null);

final worldControllerProvider =
    StateNotifierProvider<WorldController, AsyncValue<World>>((ref) {
  // Here the Controller gets the userID!
  final profile = ref.watch(profileControllerProvider);
  return WorldController(ref.read, profile);
});

class WorldController extends StateNotifier<AsyncValue<World>> {
  final Reader _read;
  final AsyncValue<UserProfile> _profile;

  WorldController(this._read, this._profile) : super(AsyncValue.loading()) {
    if (_profile.data?.value.currentWorld != null &&
        _profile.data!.value.currentWorld.isNotEmpty) {
      getWorld();
    }
  }

  /// Refresh Method for internal world
  /// Only call when user has world
  Future<void> getWorld({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final world = await _read(worldRepository)
          .getWorld(id: _profile.data!.value.currentWorld);
      if (mounted) {
        state = AsyncValue.data(world);
      }
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Call to increase currPlayers of the internal world by 1 and creates a Player
  Future<void> insertPlayer({required World world}) async {
    try {
      final worldTemp = await _read(worldRepository).getWorld(id: world.id!);

      await _read(profileControllerProvider.notifier)
          .createPlayerInWorld(worldID: worldTemp.id!);

      await _read(worldRepository).updateWorld(
          id: world.id!,
          worldInput: world.copyWith(currentPlayers: world.currentPlayers + 1));

      if (mounted) {
        state = AsyncValue.data(
            await _read(worldRepository).getWorld(id: world.id!));
      }
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }

  /// Overwrites the entire internal world by the updatedWorld and writes changes to database
  /// Recommended usage: updateWorld(internalWorld.copyWith(name: 'New Name')); - changes only the name to 'New Name'
  Future<void> updateWorld({required World updatedWorld}) async {
    try {
      await _read(worldRepository).updateWorld(
          id: _profile.data!.value.currentWorld, worldInput: updatedWorld);
      state.whenData(
          (value) => value.id == updatedWorld.id ? updatedWorld : value);
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }

  Future<void> removePlayerFromWorld() async {
    try {
      //Get profile with this world in field and update
      await _read(profileControllerProvider.notifier)
          .removePlayerFromWorld(world: state.data!.value);
      state.whenData((value) => AsyncValue.data(value));
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }

  /// Deletes a world by ID - probably not used in Frontend later on
  Future<void> deleteWorld({required String worldId}) async {
    try {
      await _read(worldRepository).deleteWorld(id: worldId);
      state.whenData((value) => AsyncValue.data(value));
    } on CustomException catch (error) {
      _read(worldExceptionProvider).state = error;
    }
  }
}
