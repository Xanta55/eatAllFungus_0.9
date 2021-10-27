import 'package:cloud_functions/cloud_functions.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final functionRepositoryProvider =
    Provider<FunctionRepository>((ref) => FunctionRepository(ref.read));

class FunctionRepository {
  final Reader _read;

  const FunctionRepository(this._read);

  Future<void> callDiggingFunction(
      String tileDescription, String playerID) async {
    try {
      HttpsCallable callable =
          _read(firebaseFunctionProvider)!.httpsCallable('digCall');
      final result = await callable({tileDescription, playerID});
      print(result);
    } on FirebaseFunctionsException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
