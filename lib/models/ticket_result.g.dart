// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketResult _$TicketResultFromJson(Map<String, dynamic> json) => TicketResult(
      votingSystem:
          VotingSystem.fromJson(json['votingSystem'] as Map<String, dynamic>),
      numericAverage: (json['numericAverage'] as num).toDouble(),
      systemAverage: json['systemAverage'] as String,
      agreement: (json['agreement'] as num).toDouble(),
    );

Map<String, dynamic> _$TicketResultToJson(TicketResult instance) =>
    <String, dynamic>{
      'votingSystem': instance.votingSystem.toJson(),
      'numericAverage': instance.numericAverage,
      'systemAverage': instance.systemAverage,
      'agreement': instance.agreement,
    };
