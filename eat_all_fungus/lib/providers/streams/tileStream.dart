import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/services/tileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileExceptionProvider = StateProvider<CustomException?>((_) => null);

final mapTileStreamProvider =
    StateNotifierProvider<MapTileStreamer, MapTile?>((ref) {
  final player = ref.watch(playerStreamProvider);
  return MapTileStreamer(ref.read, player);
});

class MapTileStreamer extends StateNotifier<MapTile?> {
  final Reader _read;
  final Player? _player;

  StreamSubscription<MapTile?>? _mapTileSubscription;

  MapTileStreamer(this._read, this._player) : super(null) {
    if (_player != null) {
      _mapTileSubscription?.cancel();
      getTileStream();
    }
  }

  Future<void> getTileStream() async {
    try {
      if (_player!.worldID.isNotEmpty) {
        final tileID =
            '${_player!.worldID};${_player!.xCoord};${_player!.yCoord}';
        _mapTileSubscription =
            _read(mapTileRepository).getTileStream(id: tileID).listen((tile) {
          state = tile;
        });
      } else {
        state = null;
      }
    } on CustomException catch (error) {
      print('TileStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _mapTileSubscription?.cancel();
    super.dispose();
  }
}
