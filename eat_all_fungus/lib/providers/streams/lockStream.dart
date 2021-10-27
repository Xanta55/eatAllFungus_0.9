import 'dart:async';

import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final lockStreamProvider = StateNotifierProvider<LockStream, bool?>((ref) {
  return LockStream(ref.read);
});

class LockStream extends StateNotifier<bool?> {
  final Reader _read;

  StreamSubscription<bool?>? _lockStreamSubscription;

  LockStream(this._read) : super(null) {
    getLockStream();
  }

  Future<void> getLockStream() async {
    try {
      _lockStreamSubscription = await _read(authRepositoryProvider)
          .getLockStream()
          .listen((lockState) => state = lockState);
    } on CustomException catch (error) {
      print('ProfileStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _lockStreamSubscription?.cancel();
    super.dispose();
  }
}
