import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/news.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseNewsRepository {
  Future<News> getNews({required String worldID, required String newsID});
  Future<List<News>> getNewsList({required String worldID});
  Future<void> createNews(
      {required World worldWithNews, required News theNews});
}

final newsRepository =
    Provider<NewsRepository>((ref) => NewsRepository(ref.read));

class NewsRepository implements BaseNewsRepository {
  final Reader _read;
  const NewsRepository(this._read);

  @override
  Future<void> createNews(
      {required World worldWithNews, required News theNews}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldWithNews.id)
          .collection('news')
          .add(theNews.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNewsQuery(
      {required String worldID}) {
    try {
      return _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('news')
          .get();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<News>> getNewsList({required String worldID}) async {
    try {
      return await getNewsQuery(worldID: worldID).then(
          (value) => value.docs.map((e) => News.fromDocument(e)).toList());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<News> getNews(
      {required String worldID, required String newsID}) async {
    try {
      final doc = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('news')
          .doc(newsID)
          .get();
      return News.fromDocument(doc);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  Stream<List<News>> getNewsStream({required String worldID}) {
    try {
      final streamOut = _read(databaseProvider)
          ?.collection('worlds')
          .doc(worldID)
          .collection('news')
          .snapshots()
          .map((event) => event.docs.map((e) => News.fromDocument(e)).toList());
      return streamOut ?? Stream.empty();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
