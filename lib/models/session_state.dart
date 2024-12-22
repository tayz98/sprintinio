import 'package:json_annotation/json_annotation.dart';

/// Enum to represent the state of a session
enum SessionState {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  voting,
  @JsonValue(3)
  result,
}
