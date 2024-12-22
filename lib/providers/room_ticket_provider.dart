import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/room_voting_provider.dart';
import 'package:sprintinio/services/impl/room_service.dart';
import 'package:sprintinio/models/room_with_userinfo.dart';

part 'room_ticket_provider.g.dart';

@riverpod
class RoomTicket extends _$RoomTicket {
  @override
  Future<RoomWithUserinfo?> build() async {
    return ref.watch(currentRoomProvider.future);
  }

  // variables used to validate the ticket input when adding a ticket
  static const int maxTicketTitleLength = 40;
  static const int maxTicketDescriptionLength = 450;
  static const int maxTicketLinkLength = 150;

  //*
  // Public user action functions to update the room session (tickets)
  //*

  bool ticketInputIsValid(Ticket newTicket) {
    if (newTicket.title.trim().isEmpty) {
      throw const FormatException('Error: Ticket must have a title.');
    }

    if (newTicket.title.length > maxTicketTitleLength) {
      throw const FormatException(
          'Error: Ticket title is too long (max $maxTicketTitleLength).');
    }
    if (newTicket.description.length > maxTicketDescriptionLength) {
      throw const FormatException(
          'Error: Ticket description is too long (max $maxTicketDescriptionLength).');
    }

    if (newTicket.link != null) {
      if (newTicket.link!.length > maxTicketLinkLength) {
        throw const FormatException(
            'Error: Ticket link is too long (max $maxTicketLinkLength).');
      }
      if (newTicket.link!.isNotEmpty &&
          !Uri.parse(newTicket.link!).isAbsolute) {
        throw const FormatException('Error: Ticket link is not a valid URL.');
      }
    }
    return true;
  }

  // Tickets

  // Add a ticket to the session
  Future<void> addTicket(Ticket ticket) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }
    // Validate the ticket input
    if (!ticketInputIsValid(ticket)) {
      return;
    }

    // Copy the session and add the ticket
    final sessionCopy = currentRoom.session!.copyWith(
      tickets: [...?currentRoom.session!.tickets, ticket],
    );

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);
  }

  // Add multiple tickets to the session
  Future<void> addTickets(List<Ticket> tickets) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    // Copy the session and add the tickets
    final sessionCopy = currentRoom.session!.copyWith(
      tickets: [...?currentRoom.session!.tickets, ...tickets],
    );

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);
  }

  // Delete a ticket from the session by its id
  Future<void> deleteTicket(String ticketId) async {
    RoomWithUserinfo? currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    // Check if the ticket is currently being voted on
    if (currentRoom.session!.votingProcess?.currentTicket?.id == ticketId) {
      // Cancel the voting process
      await ref.read(roomVotingProvider.notifier).cancelVotingProcess();
      currentRoom = ref.read(currentRoomProvider).value;
    }

    // Copy the session and remove the ticket
    final sessionCopy = currentRoom!.session!.copyWith(
      tickets: currentRoom.session!.tickets
          ?.where((ticket) => ticket.id != ticketId)
          .toList(),
    );

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);
  }
}
