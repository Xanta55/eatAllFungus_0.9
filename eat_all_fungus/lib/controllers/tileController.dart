import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/services/TileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileExceptionProvider = StateProvider<CustomException?>((_) => null);

final mapTileControllerProvider =
    StateNotifierProvider<MapTileController, Stream<MapTile>>((ref) {
  final player = ref.watch(playerControllerProvider);
  return MapTileController(ref.read, player);
});

class MapTileController extends StateNotifier<Stream<MapTile>> {
  final Reader _read;
  final AsyncValue<Player> _player;

  MapTileController(this._read, this._player) : super(Stream.empty()) {
    _player.when(data: (data) {
      getTileStream();
    }, loading: () {
      state = Stream.empty();
    }, error: (error, stackTrace) {
      state = Stream.error(error);
    });
  }

  Future<void> getTileStream() async {
    try {
      final tileID =
          '${_player.data!.value.worldID};${_player.data!.value.xCoord};${_player.data!.value.yCoord}';
      final tileStream = _read(mapTileRepository).getTileStream(id: tileID);
      if (mounted) {
        state = tileStream;
      }
    } on CustomException catch (error, stackTrace) {
      state = Stream.error(error, stackTrace);
    }
  }
}
