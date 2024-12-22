import 'package:sprintinio/models/voting_type_abstract.dart';

/// A class representing a T-Shirts voting type in the application.
class TShirts extends VotingType {
  Map<String, int> tshirtsMap = {
    'XS': 2,
    'S': 4,
    'M': 8,
    'L': 16,
    'XL': 32,
    'XXL': 64,
    'XXXL': 128,
  };

  TShirts() {
    super.name = "TShirts";
    super.nameAndValue = tshirtsMap;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
