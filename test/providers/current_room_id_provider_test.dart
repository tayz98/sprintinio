import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprintinio/providers/current_room_id_provider.dart';

void main() {
  group('CurrentRoomId Provider Tests', () {
    test('initial state should be null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Accessing the state of the provider
      final currentRoomId = container.read(currentRoomIdProvider);

      expect(currentRoomId, isNull);
    });

    test('setCurrentRoomId should set the state to the provided room ID', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Getting a reference to the CurrentRoomId notifier
      final notifier = container.read(currentRoomIdProvider.notifier);

      // Setting the current room ID
      notifier.setCurrentRoomId('12345');

      // Accessing the updated state
      final currentRoomId = container.read(currentRoomIdProvider);

      expect(currentRoomId, '12345');
    });

    test('clearCurrentRoomId should reset the state to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Getting a reference to the CurrentRoomId notifier
      final notifier = container.read(currentRoomIdProvider.notifier);

      // Setting the current room ID
      notifier.setCurrentRoomId('12345');

      // Clearing the current room ID
      notifier.clearCurrentRoomId();

      // Accessing the updated state
      final currentRoomId = container.read(currentRoomIdProvider);

      expect(currentRoomId, isNull);
    });
  });
}
