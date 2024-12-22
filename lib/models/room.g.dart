// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as String,
      name: json['name'] as String,
      votingSystem:
          VotingSystem.fromJson(json['votingSystem'] as Map<String, dynamic>),
      manageIssuesPermission: $enumDecode(
          _$ManageIssuesPermissionEnumMap, json['manageIssuesPermission']),
      shortCode: json['shortCode'] as String,
      roomUsers: (json['roomUsers'] as List<dynamic>)
          .map((e) => RoomUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      session: json['session'] == null
          ? null
          : Session.fromJson(json['session'] as Map<String, dynamic>),
      isPrivate: json['isPrivate'] as bool,
      invitedUserEmails: (json['invitedUserEmails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'votingSystem': instance.votingSystem.toJson(),
      'shortCode': instance.shortCode,
      'manageIssuesPermission':
          _$ManageIssuesPermissionEnumMap[instance.manageIssuesPermission]!,
      'roomUsers': instance.roomUsers.map((e) => e.toJson()).toList(),
      'session': instance.session?.toJson(),
      'isPrivate': instance.isPrivate,
      'invitedUserEmails': instance.invitedUserEmails,
    };

const _$ManageIssuesPermissionEnumMap = {
  ManageIssuesPermission.everyone: 'everyone',
  ManageIssuesPermission.onlyHost: 'onlyHost',
};
