import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileMapControllerProvider =
    StateNotifierProvider<TileMapController, Map<int, Map<int, MapTile>>?>(
        (ref) {
  final player = ref.watch(playerStreamProvider);
  return TileMapController(ref.read, player);
});

class TileMapController extends StateNotifier<Map<int, Map<int, MapTile>>?> {
  final Reader _read;
  final Player? _player;

  TileMapController(this._read, this._player) : super(null) {
    if (_player != null) {
      getCurrentTileMap();
    }
  }

  Future<void> getCurrentTileMap() async {
    try {
      if (_player?.worldID.isNotEmpty ?? false) {
        final tileMap = await _read(mapTileRepository)
            .getTilesInWorld(worldID: _player?.worldID ?? 'error');
        if (mounted) {
          state = tileMap;
        }
      } else {
        if (mounted) {
          state = {};
        }
      }
    } on CustomException catch (error) {
      print('TileMapController - ${error.message}');
      state = null;
    }
  }
}
