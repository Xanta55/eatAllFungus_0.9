import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:eat_all_fungus/providers/streams/townStream.dart';
import 'package:eat_all_fungus/services/profileRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BasePlayerRepository {
  Future<Player> getPlayer({required UserProfile profile});
  Stream<Player> getPlayerStream({required UserProfile profile});
  Future<List<Player>?> getPlayersInWorld({required String worldID});
  Stream<List<Player>>? getPlayersInWorldStream({required String worldID});
  Future<QuerySnapshot<Map<String, dynamic>>?> getAccordingPlayersInWorldQuery(
      {required String worldID});
  Future<String> createPlayerInWorld(
      {required String worldID, required UserProfile profile});
  Future<void> updatePlayer({required Player player});
  Future<void> updatePlayerInventory(
      {required Player playerToUpdate, required List<String> playerInventory});
  Future<void> addItemToPlayer({required Player player, required String item});
  Future<void> updatePlayerStatusEffects(
      {required Player playerToUpdate, required List<String> playerStatus});
  Future<void> addPlayerStatusEffect(
      {required Player player, required String status});
  Future<void> deletePlayer({required UserProfile profile});
  Future<void> addMembership({required Player player, required String townID});
}

final playerRepository =
    Provider<PlayerRepository>((ref) => PlayerRepository(ref.read));

class PlayerRepository implements BasePlayerRepository {
  final Reader _read;
  const PlayerRepository(this._read);

  @override
  Future<Player> getPlayer({required UserProfile profile}) async {
    try {
      final snap = await _read(databaseProvider)
          ?.collection('players')
          .doc(profile.id)
          .get();
      return Player.fromDocument(snap);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<List<Player>?> getPlayersInWorld({required String worldID}) async {
    try {
      final query = await getAccordingPlayersInWorldQuery(worldID: worldID);
      return query?.docs.map((e) => Player.fromDocument(e)).toList();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>?> getAccordingPlayersInWorldQuery(
      {required String worldID}) async {
    try {
      final output = await _read(databaseProvider)
          ?.collection('players')
          .where('worldID', isEqualTo: worldID)
          .get();
      return output;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<String> createPlayerInWorld(
      {required String worldID, required UserProfile profile}) async {
    try {
      await _read(databaseProvider)!.collection('players').doc(profile.id).set(
          Player(
                  statusEffects: [],
                  inventory: [],
                  todoList: [],
                  xCoord: 0,
                  yCoord: 0,
                  inventorySize: 8,
                  actionPoints: 10,
                  member: [],
                  worldID: worldID)
              .toDocumentNoID());
      await _read(userProfileRepository).updateProfile(
          id: profile.id!, profile: profile.copyWith(currentWorld: worldID));
      return profile.id!;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updatePlayer({required Player player}) async {
    try {
      await _read(databaseProvider)
          ?.collection('players')
          .doc(player.id)
          .update(player.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updatePlayerInventory(
      {required Player playerToUpdate,
      required List<String> playerInventory}) async {
    try {
      await updatePlayer(
          player: playerToUpdate.copyWith(inventory: playerInventory));
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<bool> addItemToPlayer(
      {required Player player, required String item}) async {
    try {
      final newInventory = player.inventory..add(item);
      if (newInventory.length > player.inventorySize) {
        return false;
      }
      await updatePlayerInventory(
          playerToUpdate: player, playerInventory: newInventory);
      return true;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updatePlayerStatusEffects(
      {required Player playerToUpdate,
      required List<String> playerStatus}) async {
    try {
      await updatePlayer(
          player: playerToUpdate.copyWith(statusEffects: playerStatus));
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> addPlayerStatusEffect(
      {required Player player, required String status}) async {
    try {
      final newStatus = player.statusEffects..add(status);
      await updatePlayerStatusEffects(
          playerToUpdate: player, playerStatus: newStatus);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deletePlayer({required UserProfile profile}) async {
    try {
      await _read(databaseProvider)
          ?.collection('players')
          .doc(profile.id)
          .delete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<Player> getPlayerStream({required UserProfile profile}) {
    try {
      final streamOut = _read(databaseProvider)
          ?.collection('players')
          .doc(profile.id)
          .snapshots()
          .map((playerDoc) => Player.fromDocument(playerDoc));
      return streamOut ?? Stream.empty();
    } on CustomException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<List<Player>> getPlayersInWorldStream({required String worldID}) {
    return _read(databaseProvider)
            ?.collection('players')
            .where('worldID', isEqualTo: worldID)
            .snapshots()
            .map((playerQuery) => playerQuery.docs
                .map((playerDoc) => Player.fromDocument(playerDoc))
                .toList()) ??
        Stream.empty();
  }

  @override
  Future<void> addMembership(
      {required Player player, required String townID}) async {
    try {
      await _read(databaseProvider)
          ?.collection('players')
          .doc(player.id)
          .update({
        'member': FieldValue.arrayUnion([townID])
      });
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
