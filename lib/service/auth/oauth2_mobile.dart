import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';

// Import for Android features.
import ''
    if (Platform.isAndroid) 'package:webview_flutter_android/webview_flutter_android.dart'
    if (Platform.isAndroid) 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// Import for iOS features.

class JsonFormatHttpClient extends http.BaseClient {
  final httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/Json';
    return httpClient.send(request);
  }
}

class BaseOauth {
  late oauth2.AuthorizationCodeGrant grant;
  late Map<String, String> parameters;
  final String clientId;
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final String? clientSecret;
  late final Uri authorizationUrl;
  Uri redirectedUrl = Uri.parse('${Config.baseUriMobile}/auth/callback/');
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

  oauth2.AuthorizationCodeGrant getSignInGrant() {
    return grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: clientSecret, httpClient: JsonFormatHttpClient());
  }

  getSignInWindow(BuildContext context) {
    authorizationUrl = grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);

    try {
      redirectAndListen(authorizationUrl, context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  redirectAndListen(Uri url, BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            // TODO: Do some error handling
            debugPrint("===============================> onWebResourceError:");
            debugPrint(error.errorType.toString());
            debugPrint(error.errorCode.toString());
            debugPrint(error.description);
          },
          onUrlChange: (change) {
            if (change.url!.contains("8000")) {
              Navigator.of(context).pop();
              PassToBackEnd.toAuthBabkend(provider: 'github');
              grant.close();
            }
          },
        ),
      )
      ..loadRequest(authorizationUrl);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return WebViewWidget(controller: controller);
        },
      ),
    );
  }
}
