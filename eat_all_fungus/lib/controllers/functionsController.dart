import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/services/functionsRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final functionControllerProvider = Provider<FunctionController>((ref) {
  return FunctionController(ref.read);
});

class FunctionController {
  final Reader _read;

  FunctionController(this._read);

  Future<void> callDigFunction() async {
    try {
      String tileDescription = _read(mapTileStreamProvider)?.description ?? "";
      String playerID = _read(playerStreamProvider)?.id ?? "";
      _read(functionRepositoryProvider)
          .callDiggingFunction(tileDescription, playerID);
    } on CustomException catch (error) {
      print('TileStream - ${error.message}');
    }
  }
}
