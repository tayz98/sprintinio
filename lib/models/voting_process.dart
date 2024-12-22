import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/ticket_result.dart';
import 'package:sprintinio/models/vote.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/models/app_timer.dart';

part 'voting_process.g.dart';

/// A class representing a voting process in the application.
///
/// A voting process is a process where users can vote on a specific [Ticket].
@JsonSerializable(explicitToJson: true)
class VotingProcess {
  /// The timer used in the voting process.
  final AppTimer? timer;

  /// The votes of the participants in the voting process.
  final Map<String, Vote> votes;

  /// The current ticket being voted on.
  final Ticket? currentTicket;

  VotingProcess({
    this.timer,
    required this.votes,
    this.currentTicket,
  });

  VotingProcess copyWith({
    AppTimer? timer,
    Map<String, Vote>? votes,
    Ticket? currentTicket,
    TicketResult? result,
  }) {
    return VotingProcess(
      timer: timer ?? this.timer,
      votes: votes ?? this.votes,
      currentTicket: currentTicket ?? this.currentTicket,
    );
  }

  VotingProcess removeCurrentTicket() {
    return VotingProcess(
      timer: timer,
      votes: votes,
    );
  }

  factory VotingProcess.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> votesJson = json['votes'];
    final Map<String, Vote> votes = {};
    votesJson.forEach((key, value) {
      votes[key] = Vote.fromJson(value);
    });
    return VotingProcess(
      timer: json['timer'] != null ? AppTimer.fromJson(json['timer']) : null,
      votes: votes,
      currentTicket: json['currentTicket'] != null
          ? Ticket.fromJson(json['currentTicket'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> votesJson = {};
    votes.forEach((key, value) {
      votesJson[key] = value.toJson(); // Use the RoomUser.id as the key
    });
    return {
      'timer': timer?.toJson(),
      'votes': votesJson,
      'currentTicket': currentTicket?.toJson(),
    };
  }
}
