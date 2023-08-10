import 'package:oauth2/oauth2.dart' as oauth2;

class GitHubAuth {
  final GitHubOauth2 _gitHubOauth2 = GitHubOauth2();

  get authorizationEndpoint => _gitHubOauth2.authorizationEndpoint;
  get tokenEndpoint => _gitHubOauth2.tokenEndpoint;

  Future signIn() async {
    var grant = _gitHubOauth2.createGitHubGrant();
    var authorizationUrl = _gitHubOauth2.getAuthorizationUrl(grant);
    print('authorizationUrl: $authorizationUrl');
    grant.close();
  }
}

class GitHubOauth2 {
  final String _clientId = 'da30cd009045f2354c82';
  final String _secret = '75e8ac127fde7544016043a55ff9963bb12af107';
  final scopes = ['read:user', 'user:email'];
  final authorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  final redirectUrl = Uri.parse('http://localhost:5000');

  oauth2.AuthorizationCodeGrant createGitHubGrant() {
    var grant = oauth2.AuthorizationCodeGrant(
        _clientId, authorizationEndpoint, tokenEndpoint,
        secret: _secret);
    return grant;
  }

  Uri getAuthorizationUrl(oauth2.AuthorizationCodeGrant grant) {
    var url = grant.getAuthorizationUrl(redirectUrl, scopes: scopes);
    return url;
  }
}
