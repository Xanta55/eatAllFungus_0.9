import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerExceptionProvider = StateProvider<CustomException?>((_) => null);

final playerControllerProvider =
    StateNotifierProvider<PlayerController, AsyncValue<Player>>((ref) {
  final profile = ref.watch(profileControllerProvider);
  return PlayerController(ref.read, profile.data?.value);
});

class PlayerController extends StateNotifier<AsyncValue<Player>> {
  final Reader _read;
  final UserProfile? _player;

  PlayerController(this._read, this._player) : super(AsyncValue.loading()) {
    if (_player != null) {
      getPlayer();
    }
  }

  Future<void> getPlayer({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final player = await _read(playerRepository).getPlayer(profile: _player!);
      if (mounted) {
        state = AsyncValue.data(player);
      }
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePlayer({required Player updatedPlayer}) async {
    try {
      await _read(playerRepository).updatePlayer(player: updatedPlayer);
      state.whenData(
          (value) => value.id == updatedPlayer.id ? updatedPlayer : value);
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> leaveWorld() async {
    try {
      final world =
          await _read(worldRepository).getWorld(id: _player!.currentWorld);
      await _read(worldRepository)
          .removePlayerFromWorld(world: world, profile: _player!);
      state.whenData((value) => AsyncValue.data(value));
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
