import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/ticket.dart';
import 'package:sprintinio/models/firebase_user.dart';
import 'package:sprintinio/models/voting_process.dart';

part 'session.g.dart';

/// A class representing a session in the application.
///
/// A session is a period of time where a list of [FirebaseUser] can participate in a [VotingProcess].
@JsonSerializable(explicitToJson: true)
class Session {
  /// The current state of the session.
  final SessionState currentState;

  /// The list of tickets in the session.
  final List<Ticket>? tickets;

  /// the voting process in the session.
  final VotingProcess? votingProcess;

  Session({
    this.tickets,
    required this.currentState,
    this.votingProcess,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  Session copyWith({
    SessionState? currentState,
    List<Ticket>? tickets,
    VotingProcess? votingProcess,
  }) {
    return Session(
      currentState: currentState ?? this.currentState,
      tickets: tickets ?? this.tickets,
      votingProcess: votingProcess ?? this.votingProcess,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session &&
          runtimeType == other.runtimeType &&
          currentState == other.currentState &&
          tickets?.length == other.tickets?.length &&
          listEquals(tickets, other.tickets);

  @override
  int get hashCode => currentState.hashCode ^ tickets.hashCode;
}
