import 'package:sprintinio/models/ticket_result.dart';
import 'ticket.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clickup_ticket.g.dart';

@JsonSerializable(explicitToJson: true)
class ClickUpTicket extends Ticket {
  final String clickUpId;

  ClickUpTicket({
    required super.title,
    required super.description,
    required super.link,
    super.result,
    super.id,
    required this.clickUpId,
  });

  @override
  ClickUpTicket copyWith({
    String? id,
    String? title,
    String? description,
    String? link,
    TicketResult? result,
    String? clickUpId,
  }) {
    return ClickUpTicket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      link: link ?? this.link,
      result: result ?? this.result,
      clickUpId: clickUpId ?? this.clickUpId,
    );
  }

  factory ClickUpTicket.fromJson(Map<String, dynamic> json) =>
      _$ClickUpTicketFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ClickUpTicketToJson(this);
}
