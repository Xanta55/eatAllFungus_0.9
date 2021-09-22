import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseWorldRepository {
  Future<World> getWorld({required String id});
  Future<QuerySnapshot<Map<String, dynamic>>?> getAvailableWorldsQuery();
  Future<List<World>?> getAvailableWorlds();
  Future<String> createEmptyWorld(
      {required String name,
      required String description,
      required int depth,
      required bool isOpen,
      required List<MapTile> mapTiles});
  Future<void> updateWorld({required String id, required World worldInput});
  Future<void> updateWorldTiles(
      {required String id, required List<MapTile> mapTiles});
  Future<void> updateWorldTile({required String id, required MapTile mapTile});
  Future<void> createWorldTile({required String id, required MapTile mapTile});
  Future<void> deleteWorld({required String id});
}

final worldRepository =
    Provider<WorldRepository>((ref) => WorldRepository(ref.read));

class WorldRepository implements BaseWorldRepository {
  final Reader _read;

  const WorldRepository(this._read);

  @override
  Future<String> createEmptyWorld(
      {required String name,
      required String description,
      required int depth,
      required bool isOpen,
      required List<MapTile> mapTiles}) async {
    try {
      final docRef = await _read(databaseProvider)!.collection('worlds').add(
          World(
                  currentPlayers: 0,
                  depth: depth,
                  description: description,
                  name: name,
                  mapTiles: [],
                  isOpen: isOpen)
              .toDocumentNoID());
      mapTiles.forEach((element) async {
        await _read(databaseProvider)!
            .collection('worlds')
            .doc(docRef.id)
            .collection('mapTiles')
            .add(element.toDocumentNoID());
      });
      return docRef.id;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<World> getWorld({required String id}) async {
    try {
      final snap =
          await _read(databaseProvider)?.collection('worlds').doc(id).get();
      return World.fromDocument(snap);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<World>?> getAvailableWorlds() async {
    try {
      final query = await getAvailableWorldsQuery();
      return query?.docs.map((e) => World.fromDocument(e)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>?> getAvailableWorldsQuery() async {
    try {
      final output = await _read(databaseProvider)
          ?.collection('worlds')
          .where('isOpen', isEqualTo: true)
          .get();
      return output;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateWorld(
      {required String id, required World worldInput}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(id)
          .update(worldInput.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateWorldTiles(
      {required String id, required List<MapTile> mapTiles}) async {
    try {
      List<String?> ids = mapTiles.map((e) => e.id).toList();
      // Query with tiles
      final query = await _read(databaseProvider)!
          .collection('worlds')
          .doc(id)
          .collection('mapTiles')
          .where('id', arrayContainsAny: ids)
          .get();
      // For each item in the query we get the corresponding Tiles from the List
      query.docs.forEach((queryMapTile) async {
        await updateWorldTile(
            id: id,
            mapTile: mapTiles
                .firstWhere((localTile) => localTile.id == queryMapTile.id));
      });
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateWorldTile(
      {required String id, required MapTile mapTile}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(id)
          .collection('mapTiles')
          .doc(mapTile.id)
          .update(mapTile.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> createWorldTile(
      {required String id, required MapTile mapTile}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(id)
          .collection('mapTiles')
          .add(mapTile.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteWorld({required String id}) async {
    try {
      await _read(databaseProvider)!.collection('worlds').doc(id).delete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
