// import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:grouping_project/config/config.dart';

import 'oauth2_web.dart'
    if (Platform.isAndroid) 'oauth2_mobile.dart'
    if (Platform.isIOS) 'oauth2_mobile.dart';

class LineAuth {
  Future signInWeb(BuildContext context) async {
    // await dotenv.load(fileName: ".env");
    // BaseOauth oauth2 = BaseOauth(
    //   clientId: dotenv.env['LINE_CLIENT_ID_WEB']!,
    //   clientSecret: dotenv.env['LINE_CLIENT_SECRET_WEB']!,
    //   scopes: dotenv.env['LINE_SCOPES']!.split(','),
    //   authorizationEndpoint: Config.lineAuthEndPoint,
    //   tokenEndpoint: Config.lineTokenEndpoint,
    // );
    // oauth2.getSignInGrant();
    // oauth2.getSignInWindow(context);
  }

  Future signInMobile(BuildContext context) async {
    // await dotenv.load(fileName: ".env");
    // BaseOauth oauth2 = BaseOauth(
    //   clientId: dotenv.env['LINE_CLIENT_ID_MOBILE']!,
    //   clientSecret: dotenv.env['LINE_CLIENT_SECRET_MOBILE']!,
    //   scopes: dotenv.env['LINE_SCOPES']!.split(','),
    //   authorizationEndpoint: Config.lineAuthEndPoint,
    //   tokenEndpoint: Config.lineTokenEndpoint,
    // );
    // oauth2.getSignInGrant();
    // oauth2.getSignInWindow(context);
  }
}
