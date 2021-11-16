import 'package:eat_all_fungus/models/radioPost.dart';

abstract class BaseRadioRepository {
  Future<List<RadioPost>> getThread(
      {required String worldID,
      required String forumID,
      required String threadID});
  Future<List<RadioPost>> createThread(
      {required String worldID,
      required String forumID,
      required String threadID,
      required String threadTitle,
      required RadioPost initialPost});
  Future<void> updateThread(
      {required String worldID,
      required String forumID,
      required RadioPost postToUpdate});
  Future<void> deleteThread(
      {required String worldID,
      required String forumID,
      required RadioPost postToDelete});
}
