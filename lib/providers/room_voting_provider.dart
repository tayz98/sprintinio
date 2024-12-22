import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/models/ticket_result.dart';
import 'package:sprintinio/models/vote.dart';
import 'package:sprintinio/models/voting_process.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/services/impl/room_service.dart';
import 'package:sprintinio/util/voting_systems.dart';
import 'package:sprintinio/models/room_with_userinfo.dart';

part 'room_voting_provider.g.dart';

@riverpod
class RoomVoting extends _$RoomVoting {
  @override
  Future<RoomWithUserinfo?> build() async {
    return ref.watch(currentRoomProvider.future);
  }

  //*
  // Private functions for the provider that are not exposed to the user
  //*

  // Finalize the voting process and save the result to the voting process and the ticket
  Future<void> finalizeVoting() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null) {
      return;
    }

    // Extract the votes from the session
    final votes = currentRoom.session?.votingProcess?.votes ?? {};

    final averageVote = _calculateAverageVote(votes);
    final agreementPercentage = _calculateAgreementPercentage(votes);

    // Load the voting system name from the room to get the system average (closest voting system value to average value)
    final votingType =
        VotingSystems.getVotingSystem(currentRoom.votingSystem.name).votingType;
    final systemAverage = votingType.getClosestNameByValue(averageVote);

    final result = TicketResult(
      votingSystem: currentRoom.votingSystem,
      numericAverage: averageVote,
      systemAverage: systemAverage,
      agreement: agreementPercentage,
    );

    // Get the currentTicket id from the session
    final currentTicketId =
        currentRoom.session?.votingProcess?.currentTicket?.id;

    // Copy current ticket with result
    final currentTicketCopy = currentRoom.session?.tickets
        ?.firstWhere((ticket) => ticket.id == currentTicketId)
        .copyWith(result: result);
    if (currentTicketCopy == null) {
      return;
    }

    // Copy the session and update the voting result and the ticket with the voting result
    final sessionCopy = currentRoom.session?.copyWith(
      votingProcess: currentRoom.session?.votingProcess
          ?.copyWith(result: result, currentTicket: currentTicketCopy),
      currentState: SessionState.result,
      tickets: currentRoom.session?.tickets?.map((ticket) {
        if (ticket.id == currentTicketId) {
          return currentTicketCopy;
        }
        return ticket;
      }).toList(),
    );

    if (sessionCopy == null) {
      return;
    }

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);
  }

  // Handles the current voting state and triggers the appropriate actions based on the state.
  // Gets called on every room update from the room_subscription_provider
  Future<void> handleVotingState() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null) {
      return;
    }

    // Check if the session is in the right state (voting)
    if (currentRoom.session?.currentState != SessionState.voting) {
      return;
    }

    // Get the current voting process from the session
    final votingProcess = currentRoom.session?.votingProcess;
    if (votingProcess == null) {
      return;
    }

    // Check if all users have voted
    final allUsersHaveVoted = votingProcess.votes.length ==
        currentRoom.roomUsers.where((user) => !user.isSpectator).length;

    if (!allUsersHaveVoted) {
      return;
    }

    // Finalize the voting process
    await finalizeVoting();
  }

  // Voting

  Future<void> submitVote(Vote vote) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    // Get the current user
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      return;
    }

    // Get the current voting process from the session
    final votingProcess = currentRoom.session!.votingProcess;
    if (votingProcess == null) {
      return;
    }

    /*
    // Copy session with updated voting process
    final sessionCopy = currentRoom.session!.copyWith(
      votingProcess: votingProcess.copyWith(
        votes: {
          ...votingProcess.votes,
          currentUser.id: vote,
        },
      ),
    );

     */

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateVote(currentRoom.id, currentUser.id, vote.vote ?? 0);
  }

  Future<void> startVotingProcess(String ticketId) async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    // Get the ticket by its id
    final ticket = currentRoom.session!.tickets
        ?.firstWhere((ticket) => ticket.id == ticketId)
        .copyWith();

    // Check if the ticket exists
    if (ticket == null) {
      return;
    }

    // reset the voting process
    final updatedVotingProcess = VotingProcess(
      currentTicket: ticket,
      votes: {},
    );

    // Copy the session and update the voting process
    final sessionCopy = currentRoom.session!.copyWith(
      currentState: SessionState.voting,
      votingProcess: updatedVotingProcess,
    );

    // Reset the vote status for all users
    final roomUsersCopy = currentRoom.roomUsers.map((roomUser) {
      return roomUser.copyWith();
    }).toList();

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);

    // Save the updated roomUsers to the room
    await ref
        .read(roomServiceProvider)
        .updateRoomUsers(currentRoom.id, roomUsersCopy);
  }

  // Start voting process for the next ticket
  Future<void> voteNextTicket() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    Ticket? nextTicket;
    // Get the next ticket
    try {
      nextTicket = currentRoom.session!.tickets
          ?.firstWhere((ticket) => ticket.result == null);

      // Check if the next ticket exists
      if (nextTicket == null) {
        throw Exception('No more tickets to vote on');
      }
    } catch (error) {
      // Cancel the voting process
      await cancelVotingProcess();
      return;
    }

    // Start the voting process for the next ticket
    return startVotingProcess(nextTicket.id);
  }

  // Method to delete user votes
  Future<void> deleteVotes() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    // Copy the session and update the voting process
    final sessionCopy = currentRoom.session!.copyWith(
      votingProcess: currentRoom.session!.votingProcess?.copyWith(votes: {}),
    );

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);
  }

  Future<void> cancelVotingProcess() async {
    final currentRoom = ref.read(currentRoomProvider).value;
    if (currentRoom == null || currentRoom.session == null) {
      return;
    }

    // Copy the session and update the state
    final sessionCopy = currentRoom.session!.copyWith(
      currentState: SessionState.pending,
      votingProcess: currentRoom.session!.votingProcess?.removeCurrentTicket(),
    );

    // Copy the roomUsers and reset the vote status
    final roomUsersCopy = currentRoom.roomUsers.map((roomUser) {
      return roomUser.copyWith();
    }).toList();

    // Save the updated session to the room
    await ref
        .read(roomServiceProvider)
        .updateSession(currentRoom.id, sessionCopy);

    // Save the updated roomUsers to the room
    await ref
        .read(roomServiceProvider)
        .updateRoomUsers(currentRoom.id, roomUsersCopy);

    // Delete the vote for all users
    await deleteVotes();
  }

  // *
  // Private util functions
  // *

  // Calculate the average of all votes
  double _calculateAverageVote(Map<String, Vote> votes) {
    if (votes.isEmpty) return 0.0;
    final total =
        votes.values.fold<int>(0, (sum, vote) => sum + (vote.vote ?? 0));
    return total / votes.length;
  }

  // Calculate the percentage of votes that agree
  double _calculateAgreementPercentage(Map<String, Vote> votes) {
    if (votes.isEmpty) return 0.0;
    final mostCommonVote = votes.values
        .map((vote) => vote.vote)
        .toList()
        .fold<Map<int, int>>({}, (map, vote) {
          if (vote != null) {
            map[vote] = (map[vote] ?? 0) + 1;
          }
          return map;
        })
        .entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final agreement =
        votes.values.where((vote) => vote.vote == mostCommonVote).length;
    return (agreement / votes.length) * 100;
  }
}
