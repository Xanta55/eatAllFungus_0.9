import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/profileStream.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final worldStreamProvider = StateNotifierProvider<WorldStream, World?>((ref) {
  final profile = ref.watch(profileStreamProvider);
  return WorldStream(ref.read, profile);
});

class WorldStream extends StateNotifier<World?> {
  final Reader _read;
  final UserProfile? _profile;

  StreamSubscription<World?>? _worldStreamSubscription;

  WorldStream(this._read, this._profile) : super(null) {
    if (_profile != null && _profile!.currentWorld.isNotEmpty) {
      _worldStreamSubscription?.cancel();
      getWorldStream();
    }
  }

  Future<void> getWorldStream() async {
    try {
      _worldStreamSubscription = await _read(worldRepository)
          .getWorldStream(id: _profile!.currentWorld)
          .listen((world) => state = world);
    } on CustomException catch (error) {
      print('WorldStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _worldStreamSubscription?.cancel();
    super.dispose();
  }
}
