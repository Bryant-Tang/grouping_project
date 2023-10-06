import "dart:io";

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grouping_project/config/config.dart';

import 'oauth2_mobile.dart'
    if (kIsWeb) 'oauth2_web.dart'
    if (Platform.isWindows) 'oauth2_web.dart';

class GoogleAuth {
  bool isLoading = false;

  Future<String> _getCorrectGoogleClientId() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      return dotenv.env['GOOGLE_CLIENT_ID_WEB']!;
    } else if (Platform.isAndroid) {
      return dotenv.env['GOOGLE_CLIENT_ID_ANDROID']!;
    } else if (Platform.isIOS) {
      return dotenv.env['GOOGLE_CLIENT_ID_IOS']!;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<String?> _getCorrectGoogleClientSecret() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      return dotenv.env['GOOGLE_CLIENT_SECRET_WEB'];
    } else if (Platform.isAndroid) {
      return dotenv.env['GOOGLE_CLIENT_SECRET_ANDROID'];
    } else if (Platform.isIOS) {
      return dotenv.env['GOOGLE_CLIENT_SECRET_IOS'];
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future signInWeb() async {
    await dotenv.load(fileName: ".env");
    BaseOauth oauth2 = BaseOauth(
      clientId: await _getCorrectGoogleClientId(),
      clientSecret: await _getCorrectGoogleClientSecret(),
      scopes: dotenv.env['GOOGLE_SCOPES']!.split(','),
      authorizationEndpoint: Config.googleAuthEndpoint,
      tokenEndpoint: Config.googleTokenEndpoint,
    );
    // oauth2.signIn();
  }

  Future signInMobile() async {
    await dotenv.load(fileName: ".env");
    BaseOauth oauth2 = BaseOauth(
      clientId: await _getCorrectGoogleClientId(),
      clientSecret: await _getCorrectGoogleClientSecret(),
      scopes: dotenv.env['GOOGLE_SCOPES']!.split(','),
      authorizationEndpoint: Config.googleAuthEndpoint,
      tokenEndpoint: Config.googleTokenEndpoint,
    );
    // oauth2.signIn();
  }
}
