import 'package:sprintinio/models/voting_system.dart';
import 'package:sprintinio/models/votingtypes/fibonacci.dart';
import 'package:sprintinio/models/votingtypes/tshirts.dart';

class VotingSystems {
  static final options = [
    VotingSystem(name: "Fibonacci", votingType: Fibonacci()),
    VotingSystem(name: "T-Shirts", votingType: TShirts()),
  ];

  static VotingSystem getVotingSystem(String name) {
    return options.firstWhere((element) => element.name == name);
  }
}
