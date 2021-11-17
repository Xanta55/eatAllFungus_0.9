import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/radioPost.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseRadioRepository {
  Future<void> createForum({
    required String worldID,
    required String forumID,
    required String forumTitle,
  });
  Future<void> createForumThread({
    required String worldID,
    required String forumID,
    required String forumTitle,
    required String threadID,
    required RadioPost post,
  });
  Future<List<String>?> getForumThreads({
    required String worldID,
    required String forumID,
  });
}

final radioRepository =
    Provider<RadioRepository>((ref) => RadioRepository(ref.read));

class RadioRepository implements BaseRadioRepository {
  final Reader _read;

  const RadioRepository(this._read);

  @override
  Future<void> createForum({
    required String worldID,
    required String forumID,
    required String forumTitle,
  }) async {
    try {
      final docRef = _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumID)
          .set({'title': forumTitle});
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<String>?> getForumThreads(
      {required String worldID, required String forumID}) async {
    try {
      final docRef = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumID)
          .collection('threads')
          .get();
      return docRef.docs.map((snapshot) => snapshot.id).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> createForumThread({
    required String worldID,
    required String forumID,
    required String forumTitle,
    required String threadID,
    required RadioPost post,
  }) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumID)
          .collection('threads')
          .doc(threadID)
          .collection('posts')
          .add(post.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
