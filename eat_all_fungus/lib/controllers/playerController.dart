import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/controllers/townController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
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
      final currTile = _read(mapTileStreamProvider)!;
      state.whenData((value) async {
        if (value.actionPoints > 0 &&
            currTile.buffShrooms <= currTile.controlPower) {
          switch (direction) {
            case 1:
              {
                if (value.yCoord < _world!.depth) {
                  final old = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: old.copyWith(
                          playersOnTile: old.playersOnTile - 1,
                          controlPower: old.controlPower - 2));

                  await updatePlayer(
                    updatedPlayer: value.copyWith(
                        yCoord: value.yCoord + 1,
                        actionPoints: value.actionPoints - 1),
                  );

                  await getPlayer();

                  final next = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: next.copyWith(
                          isVisible: true,
                          playersOnTile: next.playersOnTile + 1,
                          controlPower: next.controlPower + 2));
                }
                break;
              }
            case 2:
              {
                if (value.xCoord < _world!.depth) {
                  final old = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: old.copyWith(
                          playersOnTile: old.playersOnTile - 1,
                          controlPower: old.controlPower - 2));

                  await updatePlayer(
                    updatedPlayer: value.copyWith(
                        xCoord: value.xCoord + 1,
                        actionPoints: value.actionPoints - 1),
                  );

                  await getPlayer();

                  final next = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: next.copyWith(
                          isVisible: true,
                          playersOnTile: next.playersOnTile + 1,
                          controlPower: next.controlPower + 2));
                }
                break;
              }
            case 3:
              {
                if (value.yCoord > _world!.depth * -1) {
                  final old = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: old.copyWith(
                          playersOnTile: old.playersOnTile - 1,
                          controlPower: old.controlPower - 2));

                  await updatePlayer(
                    updatedPlayer: value.copyWith(
                        yCoord: value.yCoord - 1,
                        actionPoints: value.actionPoints - 1),
                  );

                  await getPlayer();

                  final next = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: next.copyWith(
                          isVisible: true,
                          playersOnTile: next.playersOnTile + 1,
                          controlPower: next.controlPower + 2));
                }
                break;
              }
            case 4:
              {
                if (value.xCoord > _world!.depth * -1) {
                  final old = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: old.copyWith(
                          playersOnTile: old.playersOnTile - 1,
                          controlPower: old.controlPower - 2));

                  await updatePlayer(
                    updatedPlayer: value.copyWith(
                        xCoord: value.xCoord - 1,
                        actionPoints: value.actionPoints - 1),
                  );

                  await getPlayer();

                  final next = await _read(mapTileRepository).getTile(
                      id: '${state.data!.value.worldID};${state.data!.value.xCoord};${state.data!.value.yCoord}');

                  await _read(mapTileRepository).updateTile(
                      tile: next.copyWith(
                          isVisible: true,
                          playersOnTile: next.playersOnTile + 1,
                          controlPower: next.controlPower + 2));
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

  /// returns [true] on successfull transaction
  /// return [false] if inventory is full or something went wrong
  Future<bool> addItemToInventory({required String item}) async {
    try {
      final playerState = _read(playerStreamProvider)!;
      if (playerState.inventory.length < playerState.inventorySize) {
        _read(playerRepository).updatePlayerInventory(
          playerToUpdate: playerState,
          playerInventory: playerState.inventory..add(item),
        );
        getPlayer();
        return true;
      } else {
        //getPlayer();
        return false;
      }
    } on CustomException catch (error, stackTrace) {
      print('PlayerController - Error: $error ## $stackTrace');
      return false;
    }
  }

  /// returns [true] on successfull transaction
  /// return [false] if item is not in inventory
  Future<bool> removeItemFromInventory({required String item}) async {
    try {
      final playerState = _read(playerStreamProvider)!;
      if (playerState.inventory.contains(item)) {
        _read(playerRepository).updatePlayerInventory(
          playerToUpdate: playerState,
          playerInventory: playerState.inventory..remove(item),
        );
        getPlayer();
        return true;
      } else {
        //getPlayer();
        return false;
      }
    } on CustomException catch (error, stackTrace) {
      print('PlayerController - Error: $error ## $stackTrace');
      return false;
    }
  }

  Future<void> dropItem({required String item}) async {
    try {
      final playerState = _read(playerStreamProvider)!;
      final tile = _read(mapTileStreamProvider)!;
      if (playerState.inventory.contains(item)) {
        // remove the item either way
        _read(playerRepository).updatePlayer(
            player: playerState.copyWith(
                inventory: playerState.inventory..remove(item)));
        if (tile.townOnTile.isNotEmpty) {
          // drop in Stash
          final townState = _read(townStreamProvider)!;
          if (townState.members.contains(playerState.id)) {
            _read(townControllerProvider.notifier)
                .depositItemToStash(item: item);
          }
        } else {
          // drop on Tile
          _read(mapTileRepository).updateTile(
              tile: tile.copyWith(inventory: tile.inventory..add(item)));
        }
      }
      getPlayer();
    } on CustomException catch (error, stackTrace) {
      print('PlayerController - Error: $error ## $stackTrace');
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
