import 'dart:async';

import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/services/profileRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileStreamProvider =
    StateNotifierProvider<ProfileStream, UserProfile?>((ref) {
  final user = ref.watch(authControllerProvider);
  return ProfileStream(ref.read, user?.uid);
});

class ProfileStream extends StateNotifier<UserProfile?> {
  final Reader _read;
  final String? _userID;

  StreamSubscription<UserProfile?>? _profileStreamSubscription;

  ProfileStream(this._read, this._userID) : super(null) {
    if (_userID != null) {
      _profileStreamSubscription?.cancel();
      getProfileStream();
    }
  }

  Future<void> getProfileStream() async {
    try {
      _profileStreamSubscription = _read(userProfileRepository)
          .getProfileStream(id: _userID!)
          .listen((profile) => state = profile);
    } on CustomException catch (error) {
      print('ProfileStream - ${error.message}');
      state = null;
    }
  }

  @override
  void dispose() {
    _profileStreamSubscription?.cancel();
    super.dispose();
  }
}
