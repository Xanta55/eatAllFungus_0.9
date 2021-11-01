import 'package:eat_all_fungus/constValues/constRecipes.dart';
import 'package:eat_all_fungus/constValues/helperFunctions.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/town.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
import 'package:eat_all_fungus/services/townRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerExceptionProvider = StateProvider<CustomException?>((_) => null);

final townControllerProvider =
    StateNotifierProvider<TownController, Town?>((ref) {
  final player = ref.watch(playerStreamProvider);
  final tile = ref.watch(mapTileStreamProvider);
  final town = ref.watch(townStreamProvider);
  return TownController(ref.read, player, town, tile);
});

class TownController extends StateNotifier<Town?> {
  final Reader _read;
  final Town? _town;
  final MapTile? _tile;
  final Player? _player;

  TownController(this._read, this._player, this._town, this._tile)
      : super(null) {
    if (_player != null && _town != null) {
      getTown();
    }
  }

  Future<void> getTown() async {
    state = _town;
  }

  Future<bool> constructTown({required String name}) async {
    final cArray = _tile?.inventory ?? [];
    cArray.sort();
    bool canBuild = true;
    TownRequirements.forEach((key, value) {
      print('Amount of $key: ${countAmountOfItems(cArray, key)}');
      if (countAmountOfItems(cArray, key) < value) canBuild = false;
    });
    if (canBuild) {
      TownRequirements.forEach((key, value) {
        for (int i = value; i > 0; i--) {
          cArray.remove(key);
        }
      });
      createNewTown(name: name);
      _read(mapTileRepository).updateTile(
          tile: _tile!.copyWith(inventory: cArray, townOnTile: name));
      return true;
    } else {
      return false;
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
        worldID: _player!.worldID,
        xCoord: 5,
        yCoord: 5);
    await _read(townRepository).createTown(town: testTown);
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
        worldID: _player!.worldID,
        xCoord: _player!.xCoord,
        yCoord: _player!.yCoord);
    await _read(townRepository).createTown(town: town);
  }
}
