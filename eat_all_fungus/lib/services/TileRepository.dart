import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseTileRepository {
  Future<MapTile> getTile({required String id});
  Stream<MapTile> getTileStream({required String id});
  Future<String> createEmptyTile(
      {required String worldID,
      required int xCoord,
      required int yCoord,
      required int sporeLevel,
      required int buffshrooms,
      required String description});
  Future<void> updateTile({required MapTile tile});
  Future<void> deleteTile({required String id});
  String getWorldIDFromTile({required String id});
}

final mapTileRepository =
    Provider<MapTileRepository>((ref) => MapTileRepository(ref.read));

class MapTileRepository implements BaseTileRepository {
  final Reader _read;
  const MapTileRepository(this._read);

  @override
  Future<MapTile> getTile({required String id}) async {
    try {
      print(getWorldIDFromTile(id: id));
      final snap = await _read(databaseProvider)
          ?.collection('worlds')
          .doc(getWorldIDFromTile(id: id))
          .collection('mapTiles')
          .doc(id)
          .get();
      return MapTile.fromDocument(snap!);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<String> createEmptyTile(
      {required String worldID,
      required int xCoord,
      required int yCoord,
      required int sporeLevel,
      required int buffshrooms,
      required String description}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(worldID)
          .collection('mapTiles')
          .doc('$worldID;$xCoord;$yCoord')
          .set(MapTile(
                  description: description,
                  inventory: [],
                  timesDug: 0,
                  buffShrooms: buffshrooms,
                  sporeLevel: sporeLevel,
                  visibleFor: [],
                  xCoord: xCoord,
                  yCoord: yCoord)
              .toDocumentNoID());
      return '$worldID;$xCoord;$yCoord';
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteTile({required String id}) async {
    try {
      await _read(databaseProvider)!
          .collection('worlds')
          .doc(getWorldIDFromTile(id: id))
          .collection('mapTiles')
          .doc(id)
          .delete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateTile({required MapTile tile}) async {
    try {
      await _read(databaseProvider)!
          .collection(getWorldIDFromTile(id: tile.id!))
          .doc(tile.id)
          .update(tile.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  String getWorldIDFromTile({required String id}) {
    return id.substring(0, id.indexOf(';'));
  }

  @override
  Stream<MapTile> getTileStream({required String id}) {
    try {
      final streamOut = _read(databaseProvider)
          ?.collection('worlds')
          .doc(getWorldIDFromTile(id: id))
          .collection('mapTiles')
          .doc(id)
          .snapshots()
          .map((event) => MapTile.fromDocument(event));
      return streamOut ?? Stream.empty();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
