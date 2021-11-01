import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/town.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
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
      final tempTown = await _read(townRepository).getTownOnTile(
          worldID: _currWorld!.id!, x: _currTile!.xCoord, y: _currTile!.yCoord);
      _townSubscription = _read(townRepository)
          .getTownStream(worldID: _currWorld!.id!, townID: tempTown.id!)
          .listen((event) {
        state = event;
      });
    } on CustomException catch (error) {
      print('TileStream - ${error.message}');
      state = null;
    }
  }

  Future<void> requestJoin() async {
    if (state != null && _player != null) {
      await _read(townRepository).updateTown(
          town: state!.copyWith(
              requestsToJoin: state!.requestsToJoin..add(_player!.id!)));
    }
  }

  Future<void> createNewTestTown() async {
    final Town testTown = Town(
        alliances: [],
        buildings: ['Watchtower'],
        elders: [],
        inventory: ['plank', 'plank'],
        members: [],
        requestsToJoin: [],
        distanceOfSight: 5,
        name: 'Golly Oldfield',
        wallStrength: 15,
        worldID: _currWorld!.id!,
        xCoord: 5,
        yCoord: 5);
    final docRef = await _read(townRepository).createTown(town: testTown);
    await _read(mapTileRepository)
        .updateTile(tile: _currTile!.copyWith(townOnTile: docRef));
  }

  Future<void> createNewTown({required String name}) async {
    final Town town = Town(
        alliances: [],
        buildings: [],
        elders: [_player!.id!],
        inventory: [],
        members: [_player!.id!],
        requestsToJoin: [],
        distanceOfSight: 3,
        name: name,
        wallStrength: 10,
        worldID: _currWorld!.id!,
        xCoord: _player!.xCoord,
        yCoord: _player!.yCoord);
    await _read(townRepository).createTown(town: town);
    await _read(mapTileRepository)
        .updateTile(tile: _currTile!.copyWith(townOnTile: name));
  }

  @override
  void dispose() {
    _townSubscription?.cancel();
    super.dispose();
  }
}
