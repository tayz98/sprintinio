// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      tickets: (json['tickets'] as List<dynamic>?)
          ?.map((e) => Ticket.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentState: $enumDecode(_$SessionStateEnumMap, json['currentState']),
      votingProcess: json['votingProcess'] == null
          ? null
          : VotingProcess.fromJson(
              json['votingProcess'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'currentState': _$SessionStateEnumMap[instance.currentState]!,
      'tickets': instance.tickets?.map((e) => e.toJson()).toList(),
      'votingProcess': instance.votingProcess?.toJson(),
    };

const _$SessionStateEnumMap = {
  SessionState.pending: 1,
  SessionState.voting: 2,
  SessionState.result: 3,
};
