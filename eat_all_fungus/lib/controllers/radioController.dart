import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/radioPost.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/services/radioRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final radioExceptionProvider = StateProvider<CustomException?>((_) => null);

final radioControllerProvider =
    StateNotifierProvider<RadioController, AsyncValue<List<RadioPost>>>((ref) {
  final player = ref.watch(playerStreamProvider);
  return RadioController(ref.read, player);
});

class RadioController extends StateNotifier<AsyncValue<List<RadioPost>>> {
  final Reader _read;
  final Player? _player;

  RadioController(this._read, this._player) : super(AsyncValue.loading()) {}
}
