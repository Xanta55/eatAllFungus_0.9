import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final worldListStreamExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final worldListStreamProvider =
    StateNotifierProvider<WorldListStream, List<World>?>((ref) {
  return WorldListStream(ref.read);
});

class WorldListStream extends StateNotifier<List<World>?> {
  final Reader _read;

  StreamSubscription<List<World>?>? _worldListStreamSubscription;

  WorldListStream(this._read) : super(null) {
    _worldListStreamSubscription?.cancel();
    getWorldListStream();
  }

  Future<void> getWorldListStream() async {
    try {
      _worldListStreamSubscription =
          _read(worldRepository).getWorldListStream().listen((event) {
        state = event;
      });
    } on CustomException catch (error) {
      print('WorldListStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _worldListStreamSubscription?.cancel();
    super.dispose();
  }
}
