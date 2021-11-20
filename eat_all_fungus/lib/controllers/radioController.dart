import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/radio/forum.dart';
import 'package:eat_all_fungus/models/radio/radioPost.dart';
import 'package:eat_all_fungus/models/radio/thread.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/services/radioRepository.dart';
import 'package:eat_all_fungus/views/inGame/radio/radioWidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final radioExceptionProvider = StateProvider<CustomException?>((_) => null);

final radioControllerProvider =
    StateNotifierProvider<RadioController, Future<List<RadioPost>>>((ref) {
  final player = ref.watch(playerStreamProvider);
  final thread = ref.watch(currentThreadProvider).state;
  final forum = ref.watch(currentForumProvider).state;
  return RadioController(ref.read, player, thread, forum);
});

class RadioController extends StateNotifier<Future<List<RadioPost>>> {
  final Reader _read;
  final Forum? _forum;
  final Thread? _thread;
  final Player? _player;

  RadioController(this._read, this._player, this._thread, this._forum)
      : super(Future.value([])) {
    if ((_forum?.id?.isNotEmpty ?? false) &&
        (_thread?.id?.isNotEmpty ?? false) &&
        _player != null) {
      getThreadPosts();
    }
  }

  Future<void> getThreadPosts() async {
    try {
      final newState = _read(radioRepository).getThreadPosts(
        worldID: _player!.worldID,
        forumID: _forum!.id!,
        threadID: _thread!.id!,
      );
      if (mounted) {
        state = newState;
      }
    } on CustomException catch (error) {
      _read(radioExceptionProvider).state =
          CustomException(message: error.message);
    }
  }

  Future<List<Thread>> getThreadsInForum({required String forumID}) async {
    try {
      final docs = await _read(radioRepository)
          .getForumThreads(worldID: _player!.worldID, forumID: forumID);
      return docs ?? [];
    } on CustomException catch (error) {
      _read(radioExceptionProvider).state =
          CustomException(message: error.message);
      return [];
    }
  }

  Future<List<Forum>> getForums({required List<String> forumIDs}) {
    try {
      return _read(radioRepository)
          .getForums(forumIDs: forumIDs, worldID: _player!.worldID);
    } on CustomException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
