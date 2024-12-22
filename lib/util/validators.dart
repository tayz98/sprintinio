const int maxRoomNameLength = 20;
const int maxUsernameLength = 20;
const int minShortCodeLength = 4;
const int maxShortCodeLength = 6;

String? validateShortCodeInput(String? input) {
  if (input == null) {
    return 'Please enter a room code';
  }
  if (input.trim().isEmpty) {
    return 'Please enter a room code';
  }
  if (input.length < minShortCodeLength || input.length > maxShortCodeLength) {
    return 'Room code must be $minShortCodeLength-$maxShortCodeLength characters long';
  }
  if (!RegExp(r'^[a-zA-Z0-9]*$').hasMatch(input)) {
    return 'Room code can only contain letters and numbers';
  }
  return null;
}

String? roomNameValidator(String? input) {
  if (input == null) {
    return 'Please enter a name for the room';
  }
  if (input.trim().isEmpty) {
    return 'Room name cannot be empty';
  }
  if (input.length > 20) {
    return 'Room name is too long (max $maxRoomNameLength characters)';
  }
  return null;
}

String? usernameValidator(String? input) {
  if (input == null) {
    return 'Please enter a username';
  }
  if (input.trim().isEmpty) {
    return 'Username cannot be empty';
  }
  if (input.length > maxUsernameLength) {
    return 'Username is too long (max $maxUsernameLength characters)';
  }
  if (input.contains(' ')) {
    return 'Username cannot contain spaces';
  }
  return null;
}

String? defaultTextValidator(String? input) {
  if (input == null || input.isEmpty) {
    return 'This field is required';
  }
  return null;
}
