import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/message.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseProfileRepository {
  Future<UserProfile> getProfile({required String id});
  Stream<UserProfile> getProfileStream({required String id});
  Future<String> createEmptyProfile({required String name});
  Future<void> updateProfile(
      {required String id, required UserProfile profile});
  Future<void> deleteProfile({required String id});
  Stream<List<Message>> getMessageStream({required String id});
  Future<void> sendMessage(
      {required String receiverID, required Message message});
}

final userProfileRepository =
    Provider<ProfileRepository>((ref) => ProfileRepository(ref.read));

class ProfileRepository implements BaseProfileRepository {
  final Reader _read;

  const ProfileRepository(this._read);

  @override
  Future<String> createEmptyProfile({required String name}) async {
    try {
      final _id = _read(authControllerProvider)!.uid;
      await _read(databaseProvider)!
          .collection('profiles')
          .doc(_id)
          .set(UserProfile(
            currentWorld: '',
            description: '',
            friends: [],
            hasLoggedIn: true,
            name: name,
            survivedDays: 0,
          ).toDocumentNoID());
      return _id;
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<UserProfile> getProfile({required String id}) async {
    try {
      final snap =
          await _read(databaseProvider)?.collection('profiles').doc(id).get();
      return UserProfile.fromDocument(snap);
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> updateProfile(
      {required String id, required UserProfile profile}) async {
    try {
      await _read(databaseProvider)!
          .collection('profiles')
          .doc(id)
          .update(profile.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> deleteProfile({required String id}) async {
    try {
      await _read(databaseProvider)!.collection('profiles').doc(id).delete();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<UserProfile> getProfileStream({required String id}) {
    try {
      return _read(databaseProvider)!
          .collection('profiles')
          .doc(id)
          .snapshots()
          .map((event) => UserProfile.fromDocument(event));
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<List<Message>> getMessageStream({required String id}) {
    try {
      return _read(databaseProvider)!
          .collection('profiles')
          .doc(id)
          .collection('messages')
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => Message.fromDocument(e),
                )
                .toList(),
          );
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Future<void> sendMessage(
      {required String receiverID, required Message message}) async {
    try {
      await _read(databaseProvider)!
          .collection('profiles')
          .doc(receiverID)
          .collection('messages')
          .add(message.toDocumentNoID());
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
