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

  Future<String> createThread({
    required String worldID,
    required Forum forumInput,
    required Thread threadInput,
  });

  Future<List<Thread>?> getForumThreads({
    required String worldID,
    required Forum forumInput,
  });

  Future<Thread> getThread({
    required String worldID,
    required Forum forumInput,
    required String threadID,
  });

  Future<List<RadioPost>> getThreadPosts({
    required String worldID,
    required Forum forumInput,
    required String threadID,
  });

  Future<void> createPost({
    required String worldID,
    required Forum forumInput,
    required Thread threadInput,
    required RadioPost postInput,
  });
}

final radioRepository =
    Provider<RadioRepository>((ref) => RadioRepository(ref.read));

class RadioRepository implements BaseRadioRepository {
  final Reader _read;

  const RadioRepository(this._read);

  @override
  Future<List<Thread>?> getForumThreads({
    required String worldID,
    required Forum forumInput,
  }) async {
    try {
      final docRef = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumInput.title == 'Global'
              ? forumInput.title.toLowerCase()
              : forumInput.id)
          .collection('threads')
          .orderBy('lastUpdate', descending: true)
          .get();
      return docRef.docs.map((doc) => Thread.fromDocument(doc)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<String> createThread({
    required String worldID,
    required Forum forumInput,
    required Thread threadInput,
  }) async {
    try {
      final docRef = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumInput.id)
          .collection('threads')
          .add(threadInput.toDocumentNoID());
      return docRef.id;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<Thread> getThread({
    required String worldID,
    required Forum forumInput,
    required String threadID,
  }) async {
    try {
      final threadDoc = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumInput.id)
          .collection('threads')
          .doc(threadID)
          .get();
      return Thread.fromDocument(threadDoc);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<RadioPost>> getThreadPosts({
    required String worldID,
    required Forum forumInput,
    required String threadID,
  }) async {
    try {
      final docs = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumInput.id)
          .collection('threads')
          .doc(threadID)
          .collection('posts')
          .orderBy('timeOfPost')
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

  @override
  Future<void> createPost({
    required String worldID,
    required Forum forumInput,
    required Thread threadInput,
    required RadioPost postInput,
  }) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('forums')
          .doc(forumInput.id)
          .collection('threads')
          .doc(threadInput.id)
          .collection('posts')
          .add(postInput.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
