import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/votingtypes/fibonacci.dart';
import 'package:sprintinio/models/votingtypes/tshirts.dart';

/// A class representing a voting type in the application.
///
/// A voting type is an unit for a [VotingSystem].
abstract class VotingType {
  /// The name of the voting type.
  late final String name;

  /// The names and corresponding values of the voting type.
  late final Map<String, int> nameAndValue;

  VotingType();

  List<String> get cards => nameAndValue.keys.toList();

  /// Get the closest name by a given value.
  String getClosestNameByValue(double value) {
    String? closestName;
    double? closestValue;

    nameAndValue.forEach((name, val) {
      final double currentValue = val.toDouble();
      if (closestValue == null ||
          (currentValue - value).abs() < (closestValue! - value).abs()) {
        closestName = name;
        closestValue = currentValue;
      }
    });

    return closestName!;
  }

  /// Get the name by a given value.
  String? getNameByValue(int? value) {
    if (value == null) {
      return null;
    }
    try {
      return nameAndValue.keys.firstWhere((key) => nameAndValue[key] == value);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameAndValue': nameAndValue,
    };
  }

  factory VotingType.fromJson(Map<String, dynamic> json) {
    if (json['name'] == 'Fibonacci') {
      return Fibonacci();
    } else if (json['name'] == 'TShirts') {
      return TShirts();
    } else {
      throw Exception('Unknown voting type');
    }
  }
}
