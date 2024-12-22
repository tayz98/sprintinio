class AppConfig {
  static String get baseUrl {
    return Uri.base.origin.toString();
  }
}
