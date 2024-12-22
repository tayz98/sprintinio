import 'dart:async';
import 'package:json_annotation/json_annotation.dart';

part 'app_timer.g.dart';

/// A class representing a timer in the application.
///
/// A timer can be set to limit the time a user has to perform an action.
@JsonSerializable(explicitToJson: true)
class AppTimer {
  /// The time the timer is set to.
  final DateTime time;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Timer? _timer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool _isRunning = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? _lastActionTime;

  AppTimer({required this.time});

  /// Starts the timer for a specified duration.
  void start(Duration duration, void Function() onTick) {
    stop(); // Stop any existing timer before starting a new one

    _timer = Timer.periodic(duration, (timer) {
      onTick();
    });
    _isRunning = true;
  }

  /// Stops the timer.
  void stop() {
    _timer?.cancel();
    _isRunning = false;
  }

  /// Checks if the timer is running.
  bool get isRunning => _isRunning;

  /// Sets the last action time to now.
  void updateLastActionTime() {
    _lastActionTime = DateTime.now();
  }

  /// Checks if enough time has passed since the last action.
  bool canPerformAction(Duration debounceDuration) {
    if (_lastActionTime == null) {
      return true;
    }
    return DateTime.now().difference(_lastActionTime!) > debounceDuration;
  }

  factory AppTimer.fromJson(Map<String, dynamic> json) =>
      _$AppTimerFromJson(json);

  Map<String, dynamic> toJson() => _$AppTimerToJson(this);
}
