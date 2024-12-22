import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/firebase_user.dart';
import 'package:sprintinio/providers/providers.dart';
import 'package:sprintinio/services/firestore_service_base.dart';

/// Provider for the [FirebaseUserService].
final firebaseUserServiceProvider = Provider<FirebaseUserService>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseUserService(firestore);
});

/// Service for managing firebaseUsers in Firestore.
class FirebaseUserService extends FirestoreServiceBase<FirebaseUser> {
  FirebaseUserService(firestore)
      : super(firestore, 'users', (data) => FirebaseUser.fromJson(data),
            (user) => user.toJson());

  /// Adds a new user to Firestore.
  ///
  /// Sets the document id to the user id.
  /// Returns the user.
  Future<FirebaseUser> addItem(FirebaseUser item) async {
    await collection.doc(item.id).set(item);
    return item;
  }

  /// Creates or updates a [FirebaseUser] in Firestore with the given parameters.
  Future<FirebaseUser> createOrUpdateUser({
    required String userId,
    required String username,
    required Avatar avatar,
    String? email,
  }) async {
    final userDoc = await collection.doc(userId).get();

    if (userDoc.exists) {
      // Update existing user
      final updatedUser = FirebaseUser(
        id: userId,
        username: username,
        avatar: avatar,
        email: email ?? userDoc.data()?.email,
        creationTime: userDoc.data()?.creationTime,
      );
      await collection.doc(userId).update(updatedUser.toJson());
      return updatedUser;
    } else {
      // Create new user
      final newUser = FirebaseUser(
        id: userId,
        username: username,
        avatar: avatar,
        creationTime: DateTime.now(),
        email: email,
      );
      await collection.doc(userId).set(newUser);
      return newUser;
    }
  }
}
