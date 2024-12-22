import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/voting_type_abstract.dart';
import 'package:sprintinio/util/voting_type_converter.dart';

part 'voting_system.g.dart';

/// A class representing a voting system in the application.
///
/// A voting system is a system that allows users to vote on different types of [VotingType].
@JsonSerializable(explicitToJson: true)
class VotingSystem {
  /// The name of the voting system.
  String name;

  /// The type of the voting system.
  @VotingTypeConverter()
  VotingType votingType;

  VotingSystem({
    required this.name,
    required this.votingType,
  });

  factory VotingSystem.fromJson(Map<String, dynamic> json) =>
      _$VotingSystemFromJson(json);

  Map<String, dynamic> toJson() => _$VotingSystemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VotingSystem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
