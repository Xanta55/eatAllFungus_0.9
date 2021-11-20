import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/radio/forum.dart';
import 'package:eat_all_fungus/models/radio/radioPost.dart';
import 'package:eat_all_fungus/models/radio/thread.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseRadioRepository {
  Future<List<Forum>> getForums({
    required List<String> forumIDs,
    required String worldID,
  });

  Future<void> createForumThread({
    required String worldID,
    required String forumID,
    required String forumTitle,
    required String threadID,
    required RadioPost post,
  });

  Future<List<Thread>?> getForumThreads({
    required String worldID,
    required String forumID,
  });

  Future<Thread> getThread({
    required String worldID,
    required String forumID,
    required String threadID,
  });

  Future<List<RadioPost>> getThreadPosts({
    required String worldID,
    required String forumID,
    required String threadID,
  });
}

final radioRepository =
    Provider<RadioRepository>((ref) => RadioRepository(ref.read));

class RadioRepository implements BaseRadioRepository {
  final Reader _read;

  const RadioRepository(this._read);

  @override
  Future<List<Thread>?> getForumThreads(
      {required String worldID, required String forumID}) async {
    try {
      final docRef = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumID == 'Global' ? forumID.toLowerCase() : forumID)
          .collection('threads')
          .get();
      return docRef.docs.map((doc) => Thread.fromDocument(doc)).toList();
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

  @override
  Future<Thread> getThread(
      {required String worldID,
      required String forumID,
      required String threadID}) async {
    try {
      final threadDoc = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumID)
          .collection('threads')
          .doc(threadID)
          .get();
      return Thread.fromDocument(threadDoc);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<RadioPost>> getThreadPosts(
      {required String worldID,
      required String forumID,
      required String threadID}) async {
    try {
      final docs = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumID)
          .collection('threads')
          .doc(threadID)
          .collection('posts')
          .get();
      return docs.docs.map((doc) => RadioPost.fromDocument(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<Forum>> getForums({
    required List<String> forumIDs,
    required String worldID,
  }) async {
    try {
      final docs = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .where(FieldPath.documentId, whereNotIn: forumIDs)
          .get();
      return docs.docs.map((doc) => Forum.fromDocument(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
