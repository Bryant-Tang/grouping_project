// import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:grouping_project/service/auth/oauth2.dart';
import 'package:grouping_project/config/config.dart';

class GitHubAuth {
  Future signInWeb() async {
    await dotenv.load(fileName: ".env");
    BaseOauth oauth2 = BaseOauth(
      clientId: dotenv.env['GITHUB_CLIENT_ID']!,
      clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
      scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
      authorizationEndpoint: Config.gitHubAuthEndpoint,
      tokenEndpoint: Config.gitHubTokenEndpoint,
    );
    return oauth2.signInWeb();
  }

  Future signInMobile() async {
    await dotenv.load(fileName: ".env");
    BaseOauth oauth2 = BaseOauth(
      clientId: dotenv.env['GITHUB_CLIENT_ID']!,
      clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
      scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
      authorizationEndpoint: Config.gitHubAuthEndpoint,
      tokenEndpoint: Config.gitHubTokenEndpoint,
    );
    return oauth2.signInMobile();
  }
}
