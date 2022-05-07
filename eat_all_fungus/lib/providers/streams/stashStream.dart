import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/town.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/services/townRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final stashExceptionProvider = StateProvider<CustomException?>((_) => null);

final stashStreamProvider =
    StateNotifierProvider<StashStream, List<String>?>((ref) {
  final player = ref.watch(playerStreamProvider)!;
  final town = ref.watch(townStreamProvider)!;
  return StashStream(ref.read, player, town);
});

class StashStream extends StateNotifier<List<String>?> {
  final Reader _read;
  final Player _player;
  final Town _town;

  StreamSubscription<List<String>?>? _stashStreamSubscription;

  StashStream(this._read, this._player, this._town) : super(null) {
    _stashStreamSubscription?.cancel();
    getStashStream();
  }

  Future<void> getStashStream() async {
    try {
      if (_town.members.contains(_player.id)) {
        _stashStreamSubscription = _read(townRepository)
            .getTownStashStream(
                worldID: _player.worldID,
                townID: _town.id!,
                playerID: _player.id!)
            .listen((event) {
          if (mounted) {
            state = event;
          }
        });
      } else {
        state = null;
      }
    } on CustomException catch (error) {
      print('TileStream - ${error.message}');
      state = null;
    }
  }
}
