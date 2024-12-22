import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/models/ticket.dart';

part 'ticket_result.g.dart';

/// A class representing the result of a ticket in a voting process.
///
/// The result of a [Ticket] is the average of the votes given by the participants in the [Room].
@JsonSerializable(explicitToJson: true)
class TicketResult {
  final VotingSystem votingSystem;
  final double numericAverage;
  final String systemAverage;
  final double agreement;

  TicketResult({
    required this.votingSystem,
    required this.numericAverage,
    required this.systemAverage,
    required this.agreement,
  });

  factory TicketResult.fromJson(Map<String, dynamic> json) =>
      _$TicketResultFromJson(json);

  Map<String, dynamic> toJson() => _$TicketResultToJson(this);
}
