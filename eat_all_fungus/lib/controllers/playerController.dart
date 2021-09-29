import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerExceptionProvider = StateProvider<CustomException?>((_) => null);

final playerControllerProvider =
    StateNotifierProvider<PlayerController, AsyncValue<Player>>((ref) {
  final profile = ref.watch(profileControllerProvider);
  final world = ref.watch(worldStreamProvider);
  return PlayerController(ref.read, profile.data?.value, world);
});

class PlayerController extends StateNotifier<AsyncValue<Player>> {
  final Reader _read;
  final UserProfile? _player;
  final World? _world;

  PlayerController(this._read, this._player, this._world)
      : super(AsyncValue.loading()) {
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

  Stream<Player> getPlayerStream() {
    return _read(playerRepository).getPlayerStream(profile: _player!);
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

  /// @param direction - 1: north, 2: east, 3: south, 4: west
  Future<void> movePlayer({required int direction}) async {
    try {
      await getPlayer();
      state.whenData((value) {
        if (value.actionPoints > 0) {
          switch (direction) {
            case 1:
              {
                if (value.yCoord < _world!.depth) {
                  updatePlayer(
                    updatedPlayer: value.copyWith(
                        xCoord: value.yCoord + 1,
                        actionPoints: value.actionPoints - 1),
                  );
                }
                break;
              }
            case 2:
              {
                if (value.xCoord < _world!.depth) {
                  updatePlayer(
                    updatedPlayer: value.copyWith(
                        xCoord: value.xCoord + 1,
                        actionPoints: value.actionPoints - 1),
                  );
                }
                break;
              }
            case 3:
              {
                if (value.yCoord > _world!.depth * -1) {
                  updatePlayer(
                    updatedPlayer: value.copyWith(
                        xCoord: value.yCoord - 1,
                        actionPoints: value.actionPoints - 1),
                  );
                }
                break;
              }
            case 4:
              {
                if (value.xCoord > _world!.depth * -1) {
                  updatePlayer(
                      updatedPlayer: value.copyWith(
                          xCoord: value.xCoord - 1,
                          actionPoints: value.actionPoints - 1));
                  break;
                }
              }
          }
        }
      });
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
