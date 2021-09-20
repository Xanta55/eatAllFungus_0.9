import 'dart:async';

import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// With this we provide the Provider (ironic, isnt it?)
/// We also use this call in a Reader to call the internal functions.
/// This will keep up a loose singleton pattern for controllers and services
final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read),
);

/// Controller class which will make use of the AuthService
/// User can be nullable in this, as the Stream would return 'null' before login etc
class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._read) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
