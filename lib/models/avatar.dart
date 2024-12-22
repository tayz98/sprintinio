import 'package:json_annotation/json_annotation.dart';

part 'avatar.g.dart';

@JsonSerializable()
class Avatar {
  final String avatarId;
  final String url;

  Avatar({required this.avatarId, required this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Avatar &&
          runtimeType == other.runtimeType &&
          avatarId == other.avatarId &&
          url == other.url;

  @override
  int get hashCode => avatarId.hashCode ^ url.hashCode;
}
