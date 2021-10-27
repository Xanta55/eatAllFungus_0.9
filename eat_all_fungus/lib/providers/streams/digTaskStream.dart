import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/services/digTaskRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final digTaskStreamProvider =
    StateNotifierProvider<DigTaskStreamProvider, DateTime?>((ref) {
  final player = ref.watch(playerStreamProvider);
  return DigTaskStreamProvider(ref.read, player);
});

class DigTaskStreamProvider extends StateNotifier<DateTime?> {
  final Reader _read;
  final Player? _player;

  StreamSubscription<DateTime?>? _digTaskSubscription;

  DigTaskStreamProvider(this._read, this._player) : super(null) {
    if (_player != null) {
      _digTaskSubscription?.cancel();
      getDigTaskStream();
    }
  }

  Future<void> getDigTaskStream() async {
    try {
      _digTaskSubscription = _read(digTaskRepositoryProvider)
          .getNextDigActionStream(
              playerID: _player!.id!,
              xCoord: _player!.xCoord,
              yCoord: _player!.yCoord)
          .listen((digTask) {
        state = digTask;
      });
    } on CustomException catch (error) {
      print('DigTaskStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _digTaskSubscription?.cancel();
    super.dispose();
  }
}
