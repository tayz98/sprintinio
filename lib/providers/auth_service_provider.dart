import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/providers/providers.dart';

part 'auth_service_provider.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return AuthService(auth: firebaseAuth);
}

class AuthService {
  final Logger logger = Logger();
  final FirebaseAuth auth;

  AuthService({required this.auth});

  /// Signs in a user anonymously and saves their chosen username to Firestore.
  Future<UserCredential?> signInAnonymously(
      String username, Avatar avatar) async {
    try {
      final UserCredential userCredentials = await auth.signInAnonymously();
      if (userCredentials.user == null) {
        return null;
      }
      return userCredentials;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  /// Sign in with Google.
  Future<UserCredential?> signInWithGoogle(
      String username, Avatar avatar) async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final userCredentials = await auth.signInWithPopup(googleProvider);
      if (userCredentials.user == null) {
        return null;
      }
      return userCredentials;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  /// Get the current user's authentication method.
  /// Can return "google.com" or "anonymous" or null if the user is not authenticated.
  Future<String?> getAuthMethod() async {
    final User? user = auth.currentUser;
    if (user == null) {
      return null;
    }

    // Get the list of provider data for the current user.
    final List<UserInfo> providerData = user.providerData;

    // If there is at least one provider, return the first one.
    if (providerData.isNotEmpty) {
      return providerData.first.providerId;
    }

    return "anonymous";
  }

  /// Returns the currently authenticated user.
  User? get currentUser => auth.currentUser;

  /// Provides a stream of authentication state changes.
  Stream<User?> get authChanges => auth.authStateChanges();
}
