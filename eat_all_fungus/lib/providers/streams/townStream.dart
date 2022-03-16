import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/town.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/townRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final townStreamProvider = StateNotifierProvider<TownStream, Town?>((ref) {
  final tile = ref.watch(mapTileStreamProvider);
  final world = ref.watch(worldStreamProvider);
  final player = ref.watch(playerStreamProvider);
  return TownStream(ref.read, tile, world, player);
});

class TownStream extends StateNotifier<Town?> {
  final Reader _read;
  final MapTile? _currTile;
  final World? _currWorld;
  final Player? _player;

  StreamSubscription<Town>? _townSubscription;

  TownStream(this._read, this._currTile, this._currWorld, this._player)
      : super(null) {
    if (_currTile != null && _currWorld != null) {
      _townSubscription?.cancel();
      getTownStream();
    }
  }

  Future<void> getTownStream() async {
    try {
      if (_currTile!.townOnTile.isNotEmpty) {
        final tempTown = await _read(townRepository).getTownOnTile(
            worldID: _currWorld!.id!,
            x: _currTile!.xCoord,
            y: _currTile!.yCoord);
        if (tempTown.name.isNotEmpty) {
          _townSubscription = _read(townRepository)
              .getTownStream(worldID: _currWorld!.id!, townID: tempTown.id!)
              .listen((event) {
            if (mounted) {
              state = event;
            }
          });
        } else {
          if (mounted) state = null;
        }
      } else {
        state = null;
      }
    } on CustomException catch (error) {
      print('TownStream - ${error.message}');
      state = null;
    }
  }

  Future<void> requestJoin() async {
    if (state != null && _player != null) {
      await _read(townRepository).modifyCommunityArray(
        town: state!,
        playerID: _player?.id! ?? 'error',
        arrayToModify: 'requestsToJoin',
        isRemoving: false,
      );
      //.addRequest(town: state!, playerID: _player?.id! ?? '');
    }
  }

  Future<void> removeRequestToJoin({required String playerIDToRemove}) async {
    if (state != null && _player != null) {
      // Only elders are allowed to modify Requests
      if (state!.elders.contains(_player!.id!)) {
        await _read(townRepository).modifyCommunityArray(
          town: state!,
          playerID: playerIDToRemove,
          arrayToModify: 'requestsToJoin',
          isRemoving: true,
        );
      }
    }
  }

  Future<void> acceptRequestToJoin({required String playerIDToAccept}) async {
    if (state != null && _player != null) {
      // Only elders are allowed to modify Requests
      if (state!.elders.contains(_player!.id!)) {
        await removeRequestToJoin(playerIDToRemove: playerIDToAccept);
        await _read(townRepository).modifyCommunityArray(
          town: state!,
          playerID: playerIDToAccept,
          arrayToModify: 'members',
        );
      }
    }
  }

  @override
  void dispose() {
    _townSubscription?.cancel();
    super.dispose();
  }
}
