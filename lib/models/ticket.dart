import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/ticket_result.dart';

part 'ticket.g.dart';

/// A class representing a ticket in the application.
///
/// A ticket is a task that needs to be voted during a [VotingProcess] in a [Session].
@JsonSerializable(explicitToJson: true)
class Ticket {
  /// The id of the ticket.
  final String id;

  /// The title of the ticket.
  final String title;

  /// The description of the ticket.
  final String description;

  /// The result of the ticket vote.
  final TicketResult? result;

  final String? link;

  Ticket({
    this.result,
    required this.title,
    required this.description,
    String? id,
    this.link,
  }) : id = id ?? const Uuid().v4();

  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    String? link,
    TicketResult? result,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      result: result ?? this.result,
      link: link ?? this.link,
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}
