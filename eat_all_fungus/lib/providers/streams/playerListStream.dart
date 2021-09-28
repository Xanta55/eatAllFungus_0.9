import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerListStreamProvider =
    StateNotifierProvider<PlayerListStream, List<Player>?>((ref) {
  final world = ref.watch(worldStreamProvider);
  return PlayerListStream(ref.read, world);
});

class PlayerListStream extends StateNotifier<List<Player>?> {
  final Reader _read;
  final World? _world;

  StreamSubscription<List<Player>>? _playerListStreamSubscription;

  PlayerListStream(this._read, this._world) : super(null) {
    if (_world != null) {
      getPlayerListStream();
    }
  }

  Future<void> getPlayerListStream() async {
    try {
      _playerListStreamSubscription = _read(playerRepository)
          .getPlayersInWorldStream(worldID: _world!.id!)
          .listen((player) {
        state = player;
      });
    } on CustomException catch (error) {
      print(error);
      state = null;
    }
  }

  @override
  void dispose() {
    _playerListStreamSubscription?.cancel();
    super.dispose();
  }
}
