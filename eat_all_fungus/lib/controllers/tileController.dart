import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileExceptionProvider = StateProvider<CustomException?>((_) => null);

final tileControllerProvider =
    StateNotifierProvider<TileController, MapTile?>((ref) {
  final player = ref.watch(playerStreamProvider);
  final tile = ref.watch(mapTileStreamProvider);
  return TileController(ref.read, player, tile);
});

class TileController extends StateNotifier<MapTile?> {
  final Reader _read;
  final Player? _player;
  final MapTile? _mapTile;

  TileController(this._read, this._player, this._mapTile) : super(null);

  Future<void> pickUpItem({required String item}) async {
    try {
      if (_player != null && _mapTile != null) {
        if (_player!.inventory.length < _player!.inventorySize &&
            _mapTile!.inventory.contains(item)) {
          await _read(mapTileRepository).updateTile(
              tile: _mapTile!
                  .copyWith(inventory: _mapTile!.inventory..remove(item)));
          await _read(playerRepository).updatePlayer(
              player:
                  _player!.copyWith(inventory: _player!.inventory..add(item)));
        }
      }
    } on CustomException catch (error, stackTrace) {
      print('TileController - Error: $error ## $stackTrace');
    }
  }
}
