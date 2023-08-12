import 'package:flutter/foundation.dart';
import 'dart:html' as html;

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

class GitHubAuth {
  late oauth2.AuthorizationCodeGrant _grant;
  late Uri _authorizationUrl;
  late Uri _redirectedUrl;

  get authorizationUrl => _authorizationUrl;

  Future signInMobile() async {
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
    _grant = GitHubOauth2.createGitHubGrant();
    _authorizationUrl = GitHubOauth2.getAuthorizationUrl(_grant);

    html.window.open(authorizationUrl.toString(), "_self");

    _grant.close();
  }

  Future signInWebOnCallback(Map<String, String> queryParameters) async {
    _grant = GitHubOauth2.createGitHubGrant();
    _authorizationUrl = GitHubOauth2.getAuthorizationUrl(_grant);

    debugPrint("try handleAuthorizationResponse");
    var client = await _grant.handleAuthorizationResponse(queryParameters);
    if (client != null) {
      debugPrint('client: $client');
    }
    _grant.close();
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
  static const String _clientId = 'da30cd009045f2354c82';
  static const String _secret = '75e8ac127fde7544016043a55ff9963bb12af107';
  static const scopes = ['read:user', 'user:email'];
  static final authorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static final redirectUrl = Uri.parse('http://localhost:5000');

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
