import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseDigTaskRepository {
  Future<DateTime> getNextDigAction(
      {required String playerID, required int xCoord, required int yCoord});
  Stream<DateTime> getNextDigActionStream(
      {required String playerID, required int xCoord, required int yCoord});
}

final digTaskRepositoryProvider =
    Provider<DigTaskRepository>((ref) => DigTaskRepository(ref.read));

class DigTaskRepository implements BaseDigTaskRepository {
  final Reader _read;
  const DigTaskRepository(this._read);

  @override
  Future<DateTime> getNextDigAction(
      {required String playerID,
      required int xCoord,
      required int yCoord}) async {
    try {
      final snapRef = await _read(databaseProvider)
          ?.collection('digTasks')
          .doc('$playerID;$xCoord;$yCoord')
          .get();
      if (snapRef?.exists ?? false) {
        return DateTime.fromMicrosecondsSinceEpoch(
            snapRef?.data()?['refreshAt']);
      } else {
        return DateTime(2000);
      }
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  @override
  Stream<DateTime> getNextDigActionStream(
      {required String playerID, required int xCoord, required int yCoord}) {
    try {
      final snapRef = _read(databaseProvider)
          ?.collection('digTasks')
          .doc('$playerID;$xCoord;$yCoord');

      final streamOut = snapRef?.snapshots();

      return streamOut?.map((snapshot) {
            print(snapshot.data());
            if (snapshot.data() != null) {
              return DateTime.fromMillisecondsSinceEpoch(
                  (snapshot.data()?['refreshAt'] as Timestamp)
                      .millisecondsSinceEpoch);
            } else {
              return DateTime.utc(2000);
            }
          }) ??
          Stream.empty();
    } on FirebaseException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
