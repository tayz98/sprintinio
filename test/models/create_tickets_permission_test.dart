import 'package:sprintinio/models/create_tickets_permission.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CreateTicketsPermission tests", () {
    test("Test if 'everyone' permission is correctly converted to string", () {
      expect(ManageIssuesPermission.everyone.name, 'All players');
    });

    test("Test if 'onlyHost' permission is correctly converted to string", () {
      expect(ManageIssuesPermission.onlyHost.name, 'Only Host');
    });
  });
}
