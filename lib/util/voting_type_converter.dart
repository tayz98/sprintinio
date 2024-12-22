import 'package:json_annotation/json_annotation.dart';
import 'package:sprintinio/models/voting_type_abstract.dart';
import 'package:sprintinio/models/votingtypes/fibonacci.dart';
import 'package:sprintinio/models/votingtypes/tshirts.dart';

class VotingTypeConverter
    extends JsonConverter<VotingType, Map<String, dynamic>> {
  const VotingTypeConverter();

  @override
  fromJson(Map<String, dynamic> json) {
    if (json["name"] == "Fibonacci") {
      return Fibonacci();
    } else if (json["name"] == "TShirts") {
      return TShirts();
    } else {
      throw Exception("Unknown VotingType");
    }
  }

  @override
  Map<String, dynamic> toJson(VotingType object) {
    if (object is Fibonacci) {
      return object.toJson();
    } else if (object is TShirts) {
      return object.toJson();
    } else {
      throw Exception("Unknown VotingType");
    }
  }
}
