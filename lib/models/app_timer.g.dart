// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppTimer _$AppTimerFromJson(Map<String, dynamic> json) => AppTimer(
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$AppTimerToJson(AppTimer instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
    };
