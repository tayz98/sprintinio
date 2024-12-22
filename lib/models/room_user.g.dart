// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomUser _$RoomUserFromJson(Map<String, dynamic> json) => RoomUser(
      id: json['id'] as String,
      isHost: json['isHost'] as bool,
      isSpectator: json['isSpectator'] as bool,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$RoomUserToJson(RoomUser instance) => <String, dynamic>{
      'id': instance.id,
      'isHost': instance.isHost,
      'isSpectator': instance.isSpectator,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
