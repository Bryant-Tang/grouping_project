import 'package:flutter/foundation.dart';
import 'dart:html' as html;

import 'package:oauth2/oauth2.dart' as oauth2;
import '../../config/config.dart';

class BaseOauth {
  late oauth2.AuthorizationCodeGrant grant;
  final String clientId;
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final String? clientSecret;
  late final Uri authorizationUrl;
  final Uri redirectedUrl = Uri.parse(
      '${kIsWeb ? Config.baseUriWeb : Config.baseUriMobile}/auth/callback/');
  final List<String> scopes;

  BaseOauth(
      {required this.clientId,
      required this.authorizationEndpoint,
      required this.tokenEndpoint,
      this.clientSecret,
      required this.scopes}) {
    // clientId = clientId;
    // authorizationEndpoint = authorizationEndpoint;
    // tokenEndpoint = tokenEndpoint;
    // secret = secret;
    // redirectedUrl = redirectedUrl;
    // scopes = scopes;
  }

  Future signInMobile() async {
    // TODO: implement signIn
    grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: clientSecret);
    authorizationUrl = grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);

    await redirect(authorizationUrl);
    await listen(redirectedUrl);
    await Future.delayed(Duration(seconds: 3));
    var client =
        await grant.handleAuthorizationResponse(redirectedUrl.queryParameters);
    grant.close();
  }

  Future signInWeb() async {
    grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: clientSecret);
    authorizationUrl = grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);
    // debugPrint(authorizationUrl.toString());

    var window = html.window.open(authorizationUrl.toString(), "_blank");
    await Future.delayed(Duration(seconds: 3));
    return;
  }

  Future<void> redirect(Uri url) async {
    // debugPrint('redirect url: $url');
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // }
    UnimplementedError('WIP');
  }

// This is the code that is not working yet -
  Future<void> listen(Uri url) async {
    // final linksStream = uriLinkStream.listen((Uri? uri) async {
    //   if (uri.toString().startsWith(url.toString())) {
    //     _redirectedUrl = uri!;
    //     debugPrint('redirectedUrl: $_redirectedUrl');
    //   }
    // });
    UnimplementedError('WIP');
  }
}
