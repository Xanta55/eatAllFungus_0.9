import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final playerStreamExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final playerStreamProvider =
    StateNotifierProvider<PlayerStream, Stream<Player>>((ref) {
  final profile = ref.watch(profileControllerProvider);
  return PlayerStream(ref.read, profile);
});

class PlayerStream extends StateNotifier<Stream<Player>> {
  final Reader _read;
  final AsyncValue<UserProfile> _profile;

  PlayerStream(this._read, this._profile) : super(Stream.empty()) {
    _profile.when(data: (data) {
      getPlayerStream();
    }, loading: () {
      state = Stream.empty();
    }, error: (error, stackTrace) {
      Stream.error(error);
    });
  }

  Future<void> getPlayerStream() async {
    try {
      final playerStream = _read(playerRepository)
          .getPlayerStream(profile: _profile.data!.value);
      if (mounted) {
        state = playerStream;
      }
    } on CustomException catch (error, stackTrace) {
      state = Stream.error(error, stackTrace);
    }
  }
}
