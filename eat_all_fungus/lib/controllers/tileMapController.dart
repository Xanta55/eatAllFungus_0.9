import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileMapControllerProvider = StateNotifierProvider<TileMapController,
    AsyncValue<Map<int, Map<int, MapTile>>>>((ref) {
  final player = ref.watch(playerStreamProvider);
  return TileMapController(ref.read, player);
});

class TileMapController
    extends StateNotifier<AsyncValue<Map<int, Map<int, MapTile>>>> {
  final Reader _read;
  final Player? _player;

  TileMapController(this._read, this._player) : super(AsyncValue.loading()) {
    if (_player != null) {
      getCurrentTileMap();
    }
  }

  Future<void> getCurrentTileMap() async {
    try {
      final tileMap = await _read(mapTileRepository)
          .getTilesInWorld(worldID: _player!.worldID);
      if (mounted) {
        state = AsyncValue.data(tileMap);
      }
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
