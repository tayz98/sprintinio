import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/room.dart';
part 'room_user.g.dart';

/// A class representing a user in a room.
///
/// A room user is a user that has joined a [Room].
@JsonSerializable(explicitToJson: true)
class RoomUser {
  /// The unique identifier of the room user.
  /// This is the same as the firebase user ID.
  final String id;

  /// Whether the user is the host of the room.
  bool isHost;

  /// Whether the user is a spectator in the room.
  bool isSpectator;

  /// The last time the user was updated.
  DateTime lastUpdated;

  RoomUser({
    required this.id,
    required this.isHost,
    required this.isSpectator,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory RoomUser.fromJson(Map<String, dynamic> json) =>
      _$RoomUserFromJson(json);

  Map<String, dynamic> toJson() => _$RoomUserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isHost == other.isHost &&
          isSpectator == other.isSpectator;

  @override
  int get hashCode => id.hashCode ^ isHost.hashCode ^ isSpectator.hashCode;

  RoomUser copyWith({
    String? id,
    bool? isHost,
    bool? isSpectator,
    bool? isUpdated,
  }) {
    // If at least of the copyWith values is given then set isUpdated to true
    if (id != null || isHost != null || isSpectator != null) {
      isUpdated = true;
    }

    return RoomUser(
        id: id ?? this.id,
        isHost: isHost ?? this.isHost,
        isSpectator: isSpectator ?? this.isSpectator,
        lastUpdated: isUpdated == true ? DateTime.now() : lastUpdated);
  }
}
