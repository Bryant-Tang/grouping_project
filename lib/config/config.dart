class Config {
  static String baseUri = 'http://localhost:8000';
  static String baseUriMobile = 'http://10.0.2.2:8000';

  static Uri googleAuthEndpoint =
      Uri.parse('https://accounts.google.com/o/oauth2/v2/auth');
  static Uri googleTokenEndpoint =
      Uri.parse('https://oauth2.googleapis.com/token');

  static Uri gitHubAuthEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static Uri gitHubTokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');

  static Uri lineAuthEndPoint =
      Uri.parse("https://access.line.me/oauth2/v2.1/authorize");
  static Uri lineTokenEndpoint =
      Uri.parse("https://api.line.me/oauth2/v2.1/token");
}
