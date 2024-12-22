import 'package:json_annotation/json_annotation.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote {
  int? vote;

  Vote({this.vote});

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);
}
