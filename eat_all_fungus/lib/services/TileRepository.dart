import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseTileRepository {
  Future<MapTile> getTile({required String id});
  Stream<MapTile> getTileStream({required String id});
  Future<Map<int, Map<int, MapTile>>> getTilesInWorld(
      {required String worldID});
  Future<String> createEmptyTile(
      {required String worldID,
      required int xCoord,
      required int yCoord,
      required int sporeLevel,
      required int buffshrooms,
      required bool isVisible,
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
      required bool isVisible,
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
                  isVisible: isVisible,
                  townOnTile: '',
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

  Stream<Map<int, Map<int, MapTile>>> getTileMapStream(
      {required String worldID}) {
    try {
      final streamOut = _read(databaseProvider)
          ?.collection('worlds')
          .doc(worldID)
          .collection('mapTiles')
          .snapshots()
          .map<Map<int, Map<int, MapTile>>>((event) {
        // init the map
        Map<int, Map<int, MapTile>> mapOut = Map();
        // for every document
        for (MapTile mt
            in event.docs.map((e) => MapTile.fromDocument(e)).toList()) {
          // if there is no xKey yet
          if (!mapOut.containsKey(mt.xCoord)) {
            mapOut[mt.xCoord] = Map<int, MapTile>();
          }
          // insert the entry
          mapOut[mt.xCoord]![mt.yCoord] = mt;
        }
        // return the filled map
        return mapOut;
      });
      return streamOut ?? Stream.empty();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<Map<int, Map<int, MapTile>>> getTilesInWorld(
      {required String worldID}) async {
    try {
      final tileQuery = await _read(databaseProvider)
          ?.collection('worlds')
          .doc(worldID)
          .collection('mapTiles')
          .get();
      Map<int, Map<int, MapTile>> mapOut = Map();
      for (MapTile mt
          in tileQuery!.docs.map((e) => MapTile.fromDocument(e)).toList()) {
        // if there is no xKey yet
        if (!mapOut.containsKey(mt.xCoord)) {
          mapOut[mt.xCoord] = Map<int, MapTile>();
        }
        // insert the entry
        mapOut[mt.xCoord]![mt.yCoord] = mt;
      }
      return mapOut;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
