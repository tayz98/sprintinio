import 'dart:async';
import 'package:logger/logger.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/firebase_user.dart';
import 'package:sprintinio/providers/auth_service_provider.dart';
import 'package:sprintinio/services/impl/firebase_user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  late final _firebaseUserService = ref.read(firebaseUserServiceProvider);
  late final _authService = ref.read(authServiceProvider);
  late final _currentUserNotifier = ref.read(currentUserProvider.notifier);
  final Logger logger = Logger();

  @override
  FutureOr<FirebaseUser?> build() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user != null) {
      return _firebaseUserService.getItemById(user.uid);
    }
    _listenToAuthChanges();
    return null;
  }

  void _listenToAuthChanges() {
    ref.listen(authServiceProvider.select((value) => value.authChanges),
        (previous, next) {
      next.listen((user) async {
        if (user != null) {
          // User is signed in
          state = const AsyncValue.loading();
          state = await AsyncValue.guard(() async {
            final currentUser =
                await _firebaseUserService.getItemById(user.uid);
            return currentUser;
          });
        } else {
          // User is signed out
          state = const AsyncValue.data(null);
        }
      });
    });
  }

  Future<String?> getUsernameById(String id) async {
    try {
      final user = await _firebaseUserService.getItemById(id);
      return user?.username;
    } catch (e, stackTrace) {
      logger.e('Error fetching username by ID: $id',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> addCurrentUser(FirebaseUser user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newUser = await _firebaseUserService.addItem(user);
      return newUser;
    });
  }

  Future<void> updateCurrentUser(FirebaseUser user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedUser = await _firebaseUserService.updateItem(user.id, user);
      return updatedUser;
    });
  }

  Future<void> deleteCurrentUser(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _firebaseUserService.deleteItem(id);
      return null;
    });
  }

  Future<FirebaseUser?> createOrUpdateCurrentUser({
    required String userId,
    required String username,
    required Avatar avatar,
    String? email,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _firebaseUserService.createOrUpdateUser(
        userId: userId,
        username: username,
        avatar: avatar,
        email: email,
      );
      return user;
    });
    return state.value;
  }

  Future<FirebaseUser?> signInWithGoogle(String username, Avatar avatar) async {
    final userCredentials =
        await _authService.signInWithGoogle(username, avatar);
    if (userCredentials != null) {
      return await _currentUserNotifier.createOrUpdateCurrentUser(
          userId: userCredentials.user!.uid,
          username: username,
          avatar: avatar,
          email: userCredentials.user!.email);
    }
    return null;
  }

  Future<FirebaseUser?> signInAnonymously(
      String username, Avatar avatar) async {
    final userCredentials =
        await _authService.signInAnonymously(username, avatar);
    if (userCredentials != null) {
      return await _currentUserNotifier.createOrUpdateCurrentUser(
          userId: userCredentials.user!.uid,
          username: username,
          avatar: avatar);
    }
    return null;
  }

  Future<void> updateUserProfile(String username, Avatar avatar) async {
    try {
      final user = ref.read(authServiceProvider).auth.currentUser;
      if (user == null) {
        throw Exception("No user is signed in");
      }

      final firebaseUser = await _currentUserNotifier.createOrUpdateCurrentUser(
        userId: user.uid,
        username: username,
        avatar: avatar,
      );

      if (firebaseUser == null) {
        throw Exception("Failed to update user profile in Firestore");
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
