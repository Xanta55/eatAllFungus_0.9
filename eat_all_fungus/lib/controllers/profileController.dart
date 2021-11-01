import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/models/userProfile.dart';
import 'package:eat_all_fungus/models/world.dart';
import 'package:eat_all_fungus/services/playerRepository.dart';
import 'package:eat_all_fungus/services/profileRepository.dart';
import 'package:eat_all_fungus/services/worldRepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProfileExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<UserProfile>>((ref) {
  // Here the Controller gets the userID!
  final user = ref.watch(authControllerProvider);
  return ProfileController(ref.read, user?.uid);
});

class ProfileController extends StateNotifier<AsyncValue<UserProfile>> {
  final Reader _read;
  final String? _userID;

  ProfileController(this._read, this._userID) : super(AsyncValue.loading()) {
    if (_userID != null) {
      getProfile();
    }
  }

  Future<void> getProfile({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final profile =
          await _read(userProfileRepository).getProfile(id: _userID!);
      if (mounted) {
        state = AsyncValue.data(profile);
      }
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<String> getNameFromID({required String playerID}) {
    return _read(userProfileRepository)
        .getProfile(id: playerID)
        .then((value) => value.name);
  }

  Future<void> insertEmptyProfile({required String name}) async {
    try {
      await _read(userProfileRepository).createEmptyProfile(name: name);
      state.whenData((value) => state = AsyncValue.data(value));
    } on CustomException catch (error) {
      _read(userProfileExceptionProvider).state = error;
    }
  }

  Future<void> createPlayerInWorld({required String worldID}) async {
    try {
      await _read(playerRepository)
          .createPlayerInWorld(worldID: worldID, profile: state.data!.value);
      await getProfile();
      state.whenData((value) => state = AsyncValue.data(value));
    } on CustomException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProfile({required UserProfile updatedProfile}) async {
    try {
      await _read(userProfileRepository)
          .updateProfile(id: _userID!, profile: updatedProfile);
      // m8 wtf idk either :<<
      state.whenData(
          (value) => value.id == updatedProfile.id ? updatedProfile : value);
    } on CustomException catch (error) {
      _read(userProfileExceptionProvider).state = error;
    }
  }

  Future<void> removePlayerFromWorld({required World world}) async {
    try {
      await _read(worldRepository)
          .removePlayerFromWorld(world: world, profile: state.data!.value);
      await getProfile();
      state.whenData((value) => AsyncValue.data(value));
    } on CustomException catch (error) {
      _read(userProfileExceptionProvider).state = error;
    }
  }

  Future<void> deleteProfile({required String profileId}) async {
    try {
      await _read(userProfileRepository).deleteProfile(id: profileId);
      state.whenData((value) => AsyncValue.data(value));
    } on CustomException catch (error) {
      _read(userProfileExceptionProvider).state = error;
    }
  }
}
