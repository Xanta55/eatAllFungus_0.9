import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileMapStreamProvider =
    StateNotifierProvider<TileMapStream, Map<int, Map<int, MapTile>>?>((ref) {
  final world = ref.watch(worldStreamProvider);
  return TileMapStream(ref.read, world);
});

class TileMapStream extends StateNotifier<Map<int, Map<int, MapTile>>?> {
  final Reader _read;
  final World? _world;

  StreamSubscription<Map<int, Map<int, MapTile>>>? _tileMapStreamSubscription;

  TileMapStream(this._read, this._world) : super(null) {
    if (_world != null) {
      _tileMapStreamSubscription?.cancel();
      getTileMapStream();
    }
  }

  Future<void> getTileMapStream() async {
    try {
      _tileMapStreamSubscription = _read(mapTileRepository)
          .getTileMapStream(worldID: _world!.id!)
          .listen((event) {
        state = event;
      });
    } on CustomException catch (error) {
      print('MapStream - ${error.message}');
      state = null;
    }
  }
}
