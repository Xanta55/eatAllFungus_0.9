import 'package:eat_all_fungus/models/customException.dart';
import 'package:eat_all_fungus/providers/firebaseProviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Holds all functions this service should have
abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signInAnonymously();
  User? getCurrentUser();
  Future<void> signOut();
}

/// Provider for global accessibility
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

/// Implementation fit for Firebase
class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  const AuthRepository(this._read);

  /// Returns a Stream of the local User.
  /// Will change on Login/Logout/etc
  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  /// Signin Method
  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  /// Signin Method for Anonymous login
  @override
  Future<void> signInAnonymously() async {
    try {
      await _read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  /// Returns the current User of Firebase_Auth
  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    }
  }

  /// Disconnects the Session (not the connection) and signs User out
  @override
  Future<void> signOut() async {
    try {
      await _read(firebaseAuthProvider).signOut();
      await _read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (error) {
      throw CustomException(message: error.message);
    }
  }
}
