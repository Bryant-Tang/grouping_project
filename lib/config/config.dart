class Config {
  static String baseUriWeb = 'http://localhost:8000';
  static String baseUriMobile = 'http://192.168.0.102:8000';

  static Uri googleAuthEndpoint =
      Uri.parse('https://accounts.google.com/o/oauth2/v2/auth');
  static Uri googleTokenEndpoint =
      Uri.parse('https://oauth2.googleapis.com/token');

  static Uri gitHubAuthEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static Uri gitHubTokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
}
