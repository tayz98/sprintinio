import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/models/firebase_user.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:fake_async/fake_async.dart';
import 'package:sprintinio/services/impl/firebase_user_service.dart';

import '../test_util/test_room_controller.dart';
import '../test_util/test_room_user_controller.dart';
import 'mock.dart';
import 'package:test/test.dart';

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test("check if host role is assigned correctly", () {
    fakeAsync((async) async {
      final container = createContainer();
      final room = TestRoomController.createDefaultRoom();
      final roomUser1 = TestRoomUserController.createDefaultRoomUser();
      final roomUser2 = TestRoomUserController.createDefaultRoomUser();
      roomUser1.isHost = true;
      roomUser2.isHost = false;
      room.roomUsers.add(roomUser1);
      room.roomUsers.add(roomUser2);

      //final roomRef = container.read(currentRoomProvider.notifier);
      final userRef = container.read(currentUserProvider.notifier);

      // Add data to the providers
      // await roomRef.addRoom(room);
      await userRef.addCurrentUser(container
          .read(firebaseUserServiceProvider)
          .getItemById(roomUser1.id) as FirebaseUser);
      await userRef.addCurrentUser(container
          .read(firebaseUserServiceProvider)
          .getItemById(roomUser2.id) as FirebaseUser);

      // Trigger host change
      // await roomRef.changeHost(newHost: roomUser2);

      // Refresh providers and flush microtasks
      //container.refresh(currentRoomProvider);
      container.refresh(currentUserProvider);
      async.flushMicrotasks();

      // Check results
      expect(roomUser1.isHost, false);
      expect(roomUser2.isHost, true);
    });
  });
}
