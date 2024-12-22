// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voting_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VotingProcess _$VotingProcessFromJson(Map<String, dynamic> json) =>
    VotingProcess(
      timer: json['timer'] == null
          ? null
          : AppTimer.fromJson(json['timer'] as Map<String, dynamic>),
      votes: (json['votes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Vote.fromJson(e as Map<String, dynamic>)),
      ),
      currentTicket: json['currentTicket'] == null
          ? null
          : Ticket.fromJson(json['currentTicket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VotingProcessToJson(VotingProcess instance) =>
    <String, dynamic>{
      'timer': instance.timer?.toJson(),
      'votes': instance.votes.map((k, e) => MapEntry(k, e.toJson())),
      'currentTicket': instance.currentTicket?.toJson(),
    };
