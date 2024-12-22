/// this class takes the 20 characters long room ID and generates a 4 characters long short code by taking every fifth char from it.
// /This short code can then be in the user's interface to join a room manually.
class UtilMisc {
  static String generateShortCode(String roomID) {
    String shortCode = '';
    for (int i = 4; i < roomID.length; i += 5) {
      shortCode += roomID[i];
    }
    return shortCode.toUpperCase();
  }
}
