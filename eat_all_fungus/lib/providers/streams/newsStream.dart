import 'dart:async';

import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/news.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/streams/worldStream.dart';
import 'package:eat_all_fungus/services/newsRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final newsExceptionProvider = StateProvider<CustomException?>((_) => null);

final newsStreamProvider =
    StateNotifierProvider<NewsStreamer, List<News>?>((ref) {
  final world = ref.watch(worldStreamProvider);
  return NewsStreamer(ref.read, world);
});

class NewsStreamer extends StateNotifier<List<News>?> {
  final Reader _read;
  final World? _world;

  StreamSubscription<List<News>?>? _newsStreamSubscription;

  NewsStreamer(this._read, this._world) : super(null) {
    if (_world != null) {
      _newsStreamSubscription?.cancel();
      getNewsStream();
    }
  }

  Future<void> getNewsStream() async {
    try {
      _newsStreamSubscription = _read(newsRepository)
          .getNewsStream(worldID: _world!.id!)
          .listen((event) {
        state = event;
      });
    } on CustomException catch (error) {
      print('NewsStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _newsStreamSubscription?.cancel();
    super.dispose();
  }
}
