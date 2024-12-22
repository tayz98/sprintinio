import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintinio/pages/not_found_page.dart';
import 'package:sprintinio/providers/auth_service_provider.dart';
import 'package:sprintinio/providers/create_room_provider.dart';
import 'package:sprintinio/providers/current_room_id_provider.dart';
import 'package:sprintinio/pages/customize_page.dart';
import 'package:sprintinio/pages/join_page.dart';
import 'package:sprintinio/pages/room_page.dart';
import 'package:sprintinio/pages/root_page.dart';
import 'package:sprintinio/services/impl/room_service.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final currentRoomId = ref.read(currentRoomIdProvider.notifier);
  return _routeConfig(ref: ref, currentRoomId: currentRoomId);
}

GoRouter _routeConfig(
        {required RouterRef ref, required CurrentRoomId currentRoomId}) =>
    GoRouter(
      redirect: (context, state) => _handleRedirect(ref, state, currentRoomId),
      errorBuilder: (context, state) => const NotFoundPage(),
      routes: [
        GoRoute(
          name: "root",
          path: RootPage.path,
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          name: "room",
          path: '${RoomPage.path}/:id',
          builder: (context, state) {
            final roomId = state.pathParameters['id']!;
            return RoomPage(roomId: roomId);
          },
        ),
        GoRoute(
          name: "join_with_id",
          path: '${JoinPage.path}/:id',
          builder: (context, state) {
            final roomId = state.pathParameters['id'];
            return JoinPage(roomId: roomId);
          },
        ),
        GoRoute(
          name: "join",
          path: JoinPage.path,
          builder: (context, state) => const JoinPage(),
        ),
        GoRoute(
          name: "customize",
          path: '${CustomizePage.path}/:id',
          builder: (context, state) {
            final roomId = state.pathParameters['id']!;
            final isCreateRoomMode = roomId == 'create';
            return CustomizePage(
                roomId: roomId, isCreateRoomMode: isCreateRoomMode);
          },
        ),
      ],
    );

Future<String?> _handleRedirect(
    RouterRef ref, GoRouterState state, CurrentRoomId currentRoomId) async {
  if (state.fullPath!.startsWith(RoomPage.path) &&
      state.pathParameters.containsKey('id')) {
    final String roomId = state.pathParameters['id']!;

    // Check if the room exists using the room provider
    final roomExists = await ref.read(roomServiceProvider).getItemById(roomId);
    if (roomExists == null) {
      return NotFoundPage.path;
    }

    // Check if the user is in the room
    if (await userNotInRoom(ref, roomId)) {
      return '${JoinPage.path}/$roomId';
    }
    currentRoomId.setCurrentRoomId(roomId);
  }

  if (state.fullPath!.startsWith(CustomizePage.path)) {
    final roomExists = ref.read(createRoomProvider.notifier).room;
    final String? pathId = state.pathParameters['id'];
    if (pathId != 'create') {
      return null;
    }
    if (roomExists == null && pathId == 'create') {
      return RootPage.path;
    }
  }
  return null;
}

/// Returns true if the user is not in the room
Future<bool> userNotInRoom(RouterRef ref, String roomId) async {
  final currentUser = ref.read(authServiceProvider).currentUser;
  final thisRoom = await ref.read(roomServiceProvider).getItemById(roomId);

  final bool isUserInRoom =
      thisRoom?.roomUsers.any((ru) => ru.id == currentUser?.uid) == true;

  return !isUserInRoom;
}
