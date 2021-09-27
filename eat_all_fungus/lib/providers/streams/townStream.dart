import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/town.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/services/townRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final townStreamProvider = StateNotifierProvider<TownStream, Town?>((ref) {
  final tile = ref.watch(mapTileStreamProvider);
  final world = ref.watch(worldControllerProvider);
  return TownStream(ref.read, tile, world);
});

class TownStream extends StateNotifier<Town?> {
  final Reader _read;
  final MapTile? _currTile;
  final AsyncValue<World> _currWorld;
  TownStream(this._read, this._currTile, this._currWorld) : super(null) {}

  Future<void> getTownStream() async {
    try {
      if (_currTile!.townOnTile.isEmpty) {
        state = null;
      }
      final town = await _read(townRepository).getTownOnTile(
          worldID: _currWorld.data!.value.id!,
          x: _currTile!.xCoord,
          y: _currTile!.yCoord);
      _read(townRepository)
          .getTownStream(worldID: _currWorld.data!.value.id!, townID: town.id!)
          .listen((event) {
        state = event;
      });
    } on CustomException catch (error) {
      print('TownStream - ${error.message}');
      state = null;
    }
  }
}
