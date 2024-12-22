import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/firebase_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_util/test_avatar_controller.dart';
import '../test_util/test_firebase_user_controller.dart';

void main() {
  group("FirebaseUser tests", () {
    test("FirebaseUser should be created correctly with all parameters", () {
      const String id = "id";
      const String username = "username";
      final Avatar avatar = TestAvatarController.createDefaultAvatar();
      final creationTime = DateTime.now();

      final user = FirebaseUser(
        id: id,
        username: username,
        avatar: avatar,
        creationTime: creationTime,
      );

      expect(user.id, id);
      expect(user.username, username);
      expect(user.avatar, avatar);
      expect(user.creationTime, creationTime);
    });

    test("FirebaseUser should be created with default creation time", () {
      const String id = "id";
      const String username = "username";
      final Avatar avatar = TestAvatarController.createDefaultAvatar();
      final user = FirebaseUser(
        id: id,
        username: username,
        avatar: avatar,
        creationTime: null,
      );
      expect(user.creationTime, isNotNull);
    });

    test("FirebaseUser should be converted to JSON correctly", () {
      final FirebaseUser firebaseUser =
          TestFirebaseUserController.createDefaultFirebaseUser();
      final json = firebaseUser.toJson();
      expect(json["id"], firebaseUser.id);
      expect(json["username"], firebaseUser.username);
      expect(json["avatar"], firebaseUser.avatar.toJson());
      expect(json["creationTime"], firebaseUser.creationTime.toIso8601String());
    });

    test("FirebaseUser should be created correctly from JSON", () {
      final FirebaseUser firebaseUser =
          TestFirebaseUserController.createDefaultFirebaseUser();
      final json = firebaseUser.toJson();
      final user = FirebaseUser.fromJson(json);
      expect(user.id, firebaseUser.id);
      expect(user.username, firebaseUser.username);
      expect(user.avatar, firebaseUser.avatar);
      expect(user.creationTime, firebaseUser.creationTime);
    });

    test(
        "FirebaseUser should be equal to another FirebaseUser with the same values",
        () {
      final user1 = TestFirebaseUserController.createDefaultFirebaseUser();
      final user2 = TestFirebaseUserController.createDefaultFirebaseUser();
      expect(user1, user2);
    });

    test("FirebaseUser should be correctly edited with copyWith", () {
      final user = TestFirebaseUserController.createDefaultFirebaseUser();
      const newId = "newId";
      const newUsername = "newUsername";
      final newAvatar = Avatar(avatarId: "newId", url: "newUrl");
      final newCreationTime = DateTime.now();
      final newUser = user.copyWith(
        id: newId,
        username: newUsername,
        avatar: newAvatar,
        creationTime: newCreationTime,
      );
      expect(newUser.id, newId);
      expect(newUser.username, newUsername);
      expect(newUser.avatar, newAvatar);
      expect(newUser.creationTime, newCreationTime);
    });
  });
}
