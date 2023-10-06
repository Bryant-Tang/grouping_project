import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final Uri redirectedUrl = Uri.parse('${Config.baseUri}/auth/callback/');
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

  // Future signIn() async {
  //   try {
  //     grant = oauth2.AuthorizationCodeGrant(
  //         clientId, authorizationEndpoint, tokenEndpoint,
  //         secret: clientSecret);
  //     authorizationUrl =
  //         grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);
  //     // debugPrint(authorizationUrl.toString());

  //     var window = html.window.open(authorizationUrl.toString(), "_blank");
  //     await Future.delayed(Duration(seconds: 2));
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     grant.close();
  //   }
  // }

  oauth2.AuthorizationCodeGrant getSignInGrant() {
    return grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: clientSecret);
  }

  Future getSignInWindow(BuildContext context) async {
    authorizationUrl = grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);

    try {
      var window = html.window.open(authorizationUrl.toString(), "_blank");
      debugPrint(window.location.toString());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      grant.close();
    }
  }
}
