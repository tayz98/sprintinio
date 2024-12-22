import 'package:sprintinio/models/session.dart';
import 'package:sprintinio/models/session_state.dart';
import 'package:sprintinio/models/ticket.dart';

class TestSessionController {
  static Session createDefaultSession() {
    return Session(
        currentState: SessionState.pending, tickets: List<Ticket>.empty());
  }
}
