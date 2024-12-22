import 'package:sprintinio/models/voting_type_abstract.dart';

/// A class representing a Fibonacci voting type in the application.
class Fibonacci extends VotingType {
  final Map<String, int> fibonacciMap = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '5': 5,
    '8': 8,
    '13': 13,
    '21': 21,
    '34': 34,
    '55': 55,
    '89': 89,
    '144': 144,
  };

  Fibonacci() {
    super.name = "Fibonacci";
    super.nameAndValue = fibonacciMap;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
