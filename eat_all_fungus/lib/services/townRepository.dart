import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/town.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseTownRepository {
  Future<Town> getTown({required String worldID, required String townID});
  Stream<Town> getTownStream({required String worldID, required String townID});
  Future<List<Town>> getTownList({required String worldID});
  Stream<List<Town>> getTownListStream({required String worldID});
  Future<String> createTown({required Town town});
  Future<void> updateTown({required Town town});
  Future<void> deleteTown({required Town town});
}

final townRepository =
    Provider<TownRepository>((ref) => TownRepository(ref.read));

class TownRepository implements BaseTownRepository {
  final Reader _read;
  const TownRepository(this._read);

  @override
  Future<String> createTown({required Town town}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(town.worldID)
          .collection('towns')
          .doc('${town.name};${town.xCoord};${town.yCoord}')
          .set(town.toDocumentNoID());
      return '${town.name};${town.xCoord};${town.yCoord}';
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<Town> getTown(
      {required String worldID, required String townID}) async {
    try {
      final doc = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('towns')
          .doc(townID)
          .get();
      return Town.fromDocument(doc);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  Future<Town> getTownOnTile(
      {required String worldID, required int x, required int y}) async {
    try {
      print('TownRepository - X:$x - Y:$y');
      final query = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('towns')
          .where('xCoord', isEqualTo: x)
          .where('yCoord', isEqualTo: y)
          .get();
      return Town.fromDocument(query.docs.single);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<Town>> getTownList({required String worldID}) async {
    try {
      final queryRef = await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('towns')
          .get();
      return queryRef.docs.map((e) => Town.fromDocument(e)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<List<Town>> getTownListStream({required String worldID}) {
    try {
      final queryStream = _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('towns')
          .snapshots();
      return queryStream
          .map((event) => event.docs.map((e) => Town.fromDocument(e)).toList());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<Town> getTownStream(
      {required String worldID, required String townID}) {
    try {
      final townStream = _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('towns')
          .doc(townID)
          .snapshots();
      return townStream.map((event) => Town.fromDocument(event));
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteTown({required Town town}) async {
    try {
      await _read(databaseProvider)
          ?.collection('worlds')
          .doc(town.worldID)
          .collection('towns')
          .doc(town.id)
          .delete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateTown({required Town town}) async {
    try {
      await _read(databaseProvider)
          ?.collection('worlds')
          .doc(town.worldID)
          .collection('towns')
          .doc(town.id)
          .update(town.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  Future<void> addRequest(
      {required Town town, required String playerID}) async {
    try {
      await _read(databaseProvider)
          ?.collection('worlds')
          .doc(town.worldID)
          .collection('towns')
          .doc(town.id)
          .update({
        'requestsToJoin': FieldValue.arrayUnion([playerID])
      });
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
