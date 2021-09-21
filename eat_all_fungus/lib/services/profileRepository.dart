import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseProfileRepository {
  Future<UserProfile> getProfile({required String id});
  Future<String> createEmptyProfile({required String name});
  Future<void> updateProfile(
      {required String id, required UserProfile profile});
  Future<void> deleteProfile({required String id});
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
}
