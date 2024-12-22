import 'package:sprintinio/models/avatar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Avatar tests", () {
    test("Avatar should be created correctly with id and url", () {
      const String avatarId = "id";
      const String url = "url";
      final avatar = Avatar(avatarId: avatarId, url: url);
      expect(avatar.avatarId, avatarId);
      expect(avatar.url, url);
    });

    test("Avatar should be created correctly from JSON", () {
      const String avatarId = "id";
      const String url = "url";
      final avatar = Avatar.fromJson({"avatarId": avatarId, "url": url});
      expect(avatar.avatarId, avatarId);
      expect(avatar.url, url);
    });

    test("Avatar should be converted to JSON correctly", () {
      const String avatarId = "id";
      const String url = "url";
      final avatar = Avatar(avatarId: avatarId, url: url);
      final json = avatar.toJson();
      expect(json["avatarId"], avatarId);
      expect(json["url"], url);
    });

    test("Avatar should be equal to another Avatar with the same values", () {
      const String avatarId = "id";
      const String url = "url";
      final avatar1 = Avatar(avatarId: avatarId, url: url);
      final avatar2 = Avatar(avatarId: avatarId, url: url);
      expect(avatar1, avatar2);
    });

    test("Avatar should not be equal to another Avatar with different values",
        () {
      final avatar1 = Avatar(avatarId: "id1", url: "url1");
      final avatar2 = Avatar(avatarId: "id2", url: "url2");
      expect(avatar1 != avatar2, true);
    });

    test("HashCode should be consistent to equals", () {
      const String avatarId = "id";
      const String url = "url";
      final avatar1 = Avatar(avatarId: avatarId, url: url);
      final avatar2 = Avatar(avatarId: avatarId, url: url);
      expect(avatar1.hashCode, avatar2.hashCode);
    });
  });
}
