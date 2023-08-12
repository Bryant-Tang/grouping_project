import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/service/auth/account_auth.dart';
import 'package:grouping_project/service/auth/github_auth.dart';
import 'package:grouping_project/service/auth/google_auth.dart';

enum Provier { google, github, line, account }

class AuthService {
  final GoogleAuth _googleAuth = GoogleAuth();
  final GitHubAuth _gitHubAuth = GitHubAuth();

  late Provier _provier;
  get provier => _provier;

  Future signIn({required String account, required String password}) async {
    AccountAuth accountAuth = AccountAuth();
    await accountAuth.signIn(account: account, password: password);
    const storage = FlutterSecureStorage();
    storage.readAll().then((value) => debugPrint('storage: $value'));
    _provier = Provier.account;
  }

  Future signOut() async {}

  Future googleSignIn() async {
    await _googleAuth.signIn();
    const storage = FlutterSecureStorage();
    storage.readAll().then((value) => debugPrint('storage: $value'));
    _provier = Provier.google;
  }

  Future githubSignIn() async {
    if (kIsWeb) {
      await _gitHubAuth.signInWeb();
    } else if (Platform.isAndroid || Platform.isIOS) {
      await _gitHubAuth.signInMobile();
    }
    _provier = Provier.github;
  }

  Future lineSignIn() async {
    // TODO: implement lineSignIn
    _provier = Provier.line;
  }
}

/// Used to authenticate to our backend
class AuthWithBackEndService {
  // TODO : add support for android and ios
  static Future authWithAcccountAndPassword(
      {required String account, required String password}) async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://localhost:8000/auth/signIn/');
    } else {
      url = Uri.parse('http://192.168.0.102:8000/auth/signIn/');
    }

    debugPrint('url: $url');

    http.Response response = await http.post(url,
        body: ({
          'account': account,
          'password': password,
        }));
    const storage = FlutterSecureStorage();
    await storage.write(key: 'auth-token', value: response.body);
  }

  /// When debugging on web, you need to run the backend on localhost:5000
  ///
  /// flutter run --web-hostname localhost --web-port 5000
  static Future authWithGoogle(String idToken) async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://localhost:8000/auth/google/');
    } else {
      url = Uri.parse('http://192.168.0.102:8000/auth/google/');
    }

    debugPrint('url: $url');

    http.Response response = await http.post(url,
        body: ({
          'auth_token': idToken,
        }));
    const storage = FlutterSecureStorage();
    await storage.write(key: 'auth-token', value: response.body);
  }

  static Future authWithGitHub() async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://localhost:8000/auth/google/');
    } else {
      url = Uri.parse('http://192.168.0.102:8000/auth/google/');
    }

    http.Response response = await http.post(url,
        body: ({
          'unkown': 'unkown',
        }));

    debugPrint(response.body);
  }

  static Future authWithLine() async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://localhost:8000/auth/google/');
    } else {
      url = Uri.parse('http://192.168.0.102:8000/auth/google/');
    }

    http.Response response = await http.post(url,
        body: ({
          'unkown': 'unkown',
        }));

    debugPrint(response.body);
  }
}
