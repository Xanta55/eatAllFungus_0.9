import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/news.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/newsRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final newsExceptionProvider = StateProvider<CustomException?>((_) => null);

final newsStreamProvider =
    StateNotifierProvider<NewsStreamer, Stream<List<News>>>((ref) {
  final world = ref.watch(worldControllerProvider);
  return NewsStreamer(ref.read, world);
});

class NewsStreamer extends StateNotifier<Stream<List<News>>> {
  final Reader _read;
  final AsyncValue<World> _world;
  NewsStreamer(this._read, this._world) : super(Stream.empty()) {
    _world.when(data: (data) {
      getNewsStream();
    }, loading: () {
      state = Stream.empty();
    }, error: (error, stackTrace) {
      state = Stream.error(error);
    });
  }

  Future<void> getNewsStream() async {
    try {
      final newsStream =
          _read(newsRepository).getNewsStream(worldID: _world.data!.value.id!);
      if (mounted) {
        state = newsStream;
      }
    } on CustomException catch (error, stackTrace) {
      state = Stream.error(error, stackTrace);
    }
  }
}
