import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/radio/forum.dart';
import 'package:eat_all_fungus/models/radio/radioPost.dart';
import 'package:eat_all_fungus/models/radio/thread.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/profileStream.dart';
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

  /// Returns a List of Forumobjects
  /// Does not contain the Threads, as these will be called seperatly after choosing a Forum
  Future<List<Forum>> getForums({required List<String> forumIDs}) {
    try {
      return _read(radioRepository)
          .getForums(forumIDs: forumIDs, worldID: _player!.worldID);
    } on CustomException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  /// Returns a List of Threads, which can then be used for labeling a List for example
  /// Does not contain the Posts, as these will be called seperatly after choosing a Thread
  Future<List<Thread>> getThreadsInForum() async {
    try {
      final docs = await _read(radioRepository)
          .getForumThreads(worldID: _player!.worldID, forumInput: _forum!);
      return docs ?? [];
    } on CustomException catch (error) {
      _read(radioExceptionProvider).state =
          CustomException(message: error.message);
      return [];
    }
  }

  Future<Thread> createNewThread(
      {required String threadTitle, required String threadContent}) async {
    try {
      if (_player != null && _forum != null) {
        final playerName = _read(profileStreamProvider)!.name;
        final threadToPost =
            Thread(title: threadTitle, lastUpdate: DateTime.now());
        final docID = await _read(radioRepository).createThread(
          worldID: _player!.worldID,
          forumInput: _forum!,
          threadInput: threadToPost,
        );
        await _read(radioRepository).createPost(
          worldID: _player!.worldID,
          forumInput: _forum!,
          threadInput: threadToPost.copyWith(id: docID),
          postInput: RadioPost(
            playerID: playerName,
            content: threadContent,
            timeOfPost: DateTime.now(),
          ),
        );
        return Thread(
            title: threadTitle, lastUpdate: DateTime.now(), id: docID);
      } else {
        return Thread(
            title: '', lastUpdate: DateTime.fromMicrosecondsSinceEpoch(0));
      }
    } on CustomException catch (error) {
      _read(radioExceptionProvider).state =
          CustomException(message: error.message);
      return Thread(
          title: '', lastUpdate: DateTime.fromMicrosecondsSinceEpoch(0));
    }
  }

  /// Returns the posts in a Thread
  /// Posts are stored in the provider
  /// Call this on every update you do yourself or opening of a Thread
  Future<void> getThreadPosts() async {
    try {
      final newState = _read(radioRepository).getThreadPosts(
        worldID: _player!.worldID,
        forumInput: _forum!,
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

  Future<RadioPost> createNewPost({required String postContent}) async {
    try {
      if (_player != null && _forum != null && _thread != null) {
        final playerName = _read(profileStreamProvider)!.name;
        final postToPost = RadioPost(
            playerID: playerName,
            content: postContent,
            timeOfPost: DateTime.now());
        await _read(radioRepository).createPost(
          worldID: _player!.worldID,
          forumInput: _forum!,
          threadInput: _thread!,
          postInput: postToPost,
        );
        getThreadPosts();
        return postToPost;
      } else {
        return RadioPost(
          playerID: '',
          content: '',
          timeOfPost: DateTime.fromMicrosecondsSinceEpoch(0),
        );
      }
    } on CustomException catch (error) {
      _read(radioExceptionProvider).state =
          CustomException(message: error.message);
      return RadioPost(
        playerID: '',
        content: '',
        timeOfPost: DateTime.fromMicrosecondsSinceEpoch(0),
      );
    }
  }
}
