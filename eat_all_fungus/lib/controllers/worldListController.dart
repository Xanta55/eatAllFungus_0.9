import 'dart:math';

import 'package:eat_all_fungus/constValues/tileDescriptions.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/news.dart';
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
          mapTiles: world.mapTiles ?? [],
          news: world.news ?? []);
      getWorlds();
      state.whenData((value) => state = AsyncValue.data(value));
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createTestWorld({required int depth}) async {
    try {
      List<MapTile> toUpload = <MapTile>[];
      var rng = Random();
      String description;
      for (int x = -depth; x <= depth; x++) {
        for (int y = -depth; y <= depth; y++) {
          description = 'Empty Tile';
          if ((x > depth / 2) ||
              (x < ((depth / 2) * -1)) ||
              (y > depth / 2) ||
              (y < ((depth / 2) * -1))) {
            rng.nextInt(100) > 90
                ? description =
                    tileDescriptions[rng.nextInt(tileDescriptions.length)]
                : description = 'Empty Tile';
          }
          toUpload.add(MapTile(
              description: description,
              inventory: [],
              timesDug: 0,
              buffShrooms: 0,
              sporeLevel: 0,
              isVisible: (x == 0 && y == 0),
              playersOnTile: 0,
              townOnTile: '',
              xCoord: x,
              yCoord: y));
        }
      }
      await _read(worldRepository).createEmptyWorld(
          name: 'Crooked Rothome',
          description: 'Small 25x25 World for beginners',
          depth: depth,
          isOpen: true,
          mapTiles: toUpload,
          news: [News(news: 'World is still DEAD')]);
      getWorlds();
      state.whenData((value) => state = AsyncValue.data(value));
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
