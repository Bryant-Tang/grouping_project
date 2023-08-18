import 'package:flutter/foundation.dart';
import 'dart:html' as html;

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GitHubAuth {
  late oauth2.AuthorizationCodeGrant _grant;
  late Uri _authorizationUrl;
  late Uri _redirectedUrl;

  get authorizationUrl => _authorizationUrl;

  Future signInMobile() async {
    await dotenv.load(fileName: ".env");
    // TODO: implement signIn
    _grant = GitHubOauth2.createGitHubGrant();
    _authorizationUrl = GitHubOauth2.getAuthorizationUrl(_grant);

    await redirect(authorizationUrl);
    await listen(GitHubOauth2.redirectUrl);

    var client = await _grant
        .handleAuthorizationResponse(_redirectedUrl.queryParameters);
    _grant.close();
  }

  Future signInWeb() async {
    await dotenv.load(fileName: ".env");
    _grant = GitHubOauth2.createGitHubGrant();
    _authorizationUrl = GitHubOauth2.getAuthorizationUrl(_grant);

    var window = html.window.open(authorizationUrl.toString(), "_blank");
    return;
  }

  Future<void> redirect(Uri url) async {
    debugPrint('redirect url: $url');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

// This is the code that is not working yet -
  Future<void> listen(Uri url) async {
    final linksStream = uriLinkStream.listen((Uri? uri) async {
      if (uri.toString().startsWith(url.toString())) {
        _redirectedUrl = uri!;
        debugPrint('redirectedUrl: $_redirectedUrl');
      }
    });
  }
}

class GitHubOauth2 {
  static final String _clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  static final String _secret = dotenv.env['GITHUB_CLIENT_SECRET']!;
  static const scopes = ['read:user', 'user:email'];
  static final authorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static final redirectUrl = Uri.parse('http://localhost:8000/auth/callback/');

  static oauth2.AuthorizationCodeGrant createGitHubGrant() {
    var grant = oauth2.AuthorizationCodeGrant(
        _clientId, authorizationEndpoint, tokenEndpoint,
        secret: _secret);
    return grant;
  }

  static Uri getAuthorizationUrl(oauth2.AuthorizationCodeGrant grant) {
    var url = grant.getAuthorizationUrl(redirectUrl, scopes: scopes);
    return url;
  }
}
