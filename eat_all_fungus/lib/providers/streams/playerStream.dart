import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/streams/profileStream.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerStreamExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final playerStreamProvider =
    StateNotifierProvider<PlayerStream, Player?>((ref) {
  final profile = ref.watch(profileStreamProvider);
  return PlayerStream(ref.read, profile);
});

class PlayerStream extends StateNotifier<Player?> {
  final Reader _read;
  final UserProfile? _profile;

  StreamSubscription<Player?>? _playerStreamSubscription;

  PlayerStream(this._read, this._profile) : super(null) {
    if (_profile != null) {
      _playerStreamSubscription?.cancel();
      getPlayerStream();
    }
  }

  Future<void> getPlayerStream() async {
    try {
      _playerStreamSubscription = _read(playerRepository)
          .getPlayerStream(profile: _profile!)
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
    _playerStreamSubscription?.cancel();
    super.dispose();
  }
}
