// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseUser _$FirebaseUserFromJson(Map<String, dynamic> json) => FirebaseUser(
      id: json['id'] as String,
      username: json['username'] as String,
      avatar: Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      creationTime: json['creationTime'] == null
          ? null
          : DateTime.parse(json['creationTime'] as String),
      email: json['email'] as String?,
    );

Map<String, dynamic> _$FirebaseUserToJson(FirebaseUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar.toJson(),
      'creationTime': instance.creationTime.toIso8601String(),
      'email': instance.email,
    };
