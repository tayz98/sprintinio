import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:logger/logger.dart';
import 'package:sprintinio/providers/room_ticket_provider.dart';
import 'package:sprintinio/models/clickup_ticket.dart';
import 'package:sprintinio/util/webauth_config.dart';

class ClickUpApi {
  static String authUrl =
      "https://app.clickup.com/api?client_id=${ClickUpConfig.clientId}&redirect_uri=${ClickUpConfig.redirectUri}";
  static const String callbackUrlScheme = 'https';
  static final Logger _logger = Logger();

  /// Authenticate the user with ClickUp using the OAuth2 flow
  static Future<bool> authenticateClickUp(StateNotifier notifier) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme,
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        throw Exception('Failed to fetch authorization code');
      }
      final accessTokenWasReceived = await getAccessToken(code, notifier);
      if (!accessTokenWasReceived) {
        throw Exception('Failed to fetch access token');
      }
      return true;
    } catch (e) {
      _logger.e('Failed to authenticate with ClickUp: $e');
      return false;
    }
  }

  /// Fetch the Access Token from the ClickUp API
  static Future<bool> getAccessToken(
      String authorizationCode, StateNotifier notifier) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west3')
              .httpsCallable("getAccessToken");
      final HttpsCallableResult res = await callable.call({
        'code': authorizationCode,
      });
      final data = res.data as Map<String, dynamic>;
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      final accessToken = data['access_token'];
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      notifier.state = accessToken;
      return true;
    } catch (e) {
      _logger.e('Failed to fetch access token: $e');
      return false;
    }
  }

  /// Fetch tasks from ClickUp
  static Future<bool> fetchTasks(
      String url, String accessToken, RoomTicket roomTicketProvider) async {
    try {
      String id = '';
      Logger().i('ID: $url');
      final HttpsCallable callable;
      if (url.contains('/li/')) {
        callable = FirebaseFunctions.instanceFor(region: 'europe-west3')
            .httpsCallable("getTasksFromList");
      } else if (url.contains('/l/')) {
        id = extractIdFromSpecificList(url);
        callable = FirebaseFunctions.instanceFor(region: 'europe-west3')
            .httpsCallable("getTasksFromList");
      } else {
        callable = FirebaseFunctions.instanceFor(region: 'europe-west3')
            .httpsCallable("getTaskById");
        id = url.split('/').last;
      }
      if (id.trim().isEmpty) {
        throw Exception('Input could not be parsed correctly');
      }
      final HttpsCallableResult res = await callable.call({
        'id': id,
        'accessToken': accessToken,
      });
      final data = res.data as Map<String, dynamic>;
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      createTasksFromClickUpData(data, url, roomTicketProvider);
      return true;
    } catch (e) {
      _logger.e('Failed to fetch tasks from ClickUp: $e');
      return false;
    }
  }
}

String extractIdFromSpecificList(String url) {
  final RegExp regex;
  regex = RegExp(r'-(\d+)-');
  final Match? match = regex.firstMatch(url);
  if (match != null) {
    return match.group(1) ?? '';
  } else {
    throw Exception('Invalid URL format');
  }
}

void createTasksFromClickUpData(Map<String, dynamic> data, String url,
    RoomTicket roomTicketProvider) async {
  final List<ClickUpTicket> tickets = [];

  if (data['tasks'] != null) {
    for (final task in data['tasks']) {
      final ticket = ClickUpTicket(
        clickUpId: task['id'],
        title: task['name'],
        link: url,
        description: task['description'],
      );
      if (roomTicketProvider.ticketInputIsValid(ticket)) {
        tickets.add(ticket);
      }
    }
  } else {
    final ticket = ClickUpTicket(
      clickUpId: data['id'],
      title: data['name'],
      link: url,
      description: data['description'],
    );
    if (roomTicketProvider.ticketInputIsValid(ticket)) {
      tickets.add(ticket);
    }
  }
  await roomTicketProvider.addTickets(tickets);
}
