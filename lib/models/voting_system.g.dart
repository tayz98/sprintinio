// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voting_system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VotingSystem _$VotingSystemFromJson(Map<String, dynamic> json) => VotingSystem(
      name: json['name'] as String,
      votingType: const VotingTypeConverter()
          .fromJson(json['votingType'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VotingSystemToJson(VotingSystem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'votingType': const VotingTypeConverter().toJson(instance.votingType),
    };
