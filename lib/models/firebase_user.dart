import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/avatar.dart';
import 'package:sprintinio/models/room.dart';

part 'firebase_user.g.dart';

/// A class representing a user in the application.
///
/// A user is a person that can join a [Room].
@JsonSerializable(explicitToJson: true)
class FirebaseUser {
  /// The unique identifier of the user.
  final String id;

  /// The username of the user.
  final String username;

  /// The avatar of the user.
  final Avatar avatar;

  /// The creation time of the user.
  final DateTime creationTime;

  final String? email;

  FirebaseUser({
    required this.id,
    required this.username,
    required this.avatar,
    required DateTime? creationTime,
    this.email,
  }) : creationTime = creationTime ?? DateTime.now();

  factory FirebaseUser.fromJson(Map<String, dynamic> json) =>
      _$FirebaseUserFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseUserToJson(this);

  FirebaseUser copyWith({
    String? id,
    String? username,
    Avatar? avatar,
    DateTime? creationTime,
    String? email,
  }) {
    return FirebaseUser(
      id: id ?? this.id,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      creationTime: creationTime ?? this.creationTime,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirebaseUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          avatar == other.avatar &&
          creationTime == other.creationTime &&
          email == other.email;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      avatar.hashCode ^
      creationTime.hashCode ^
      email.hashCode;
}
