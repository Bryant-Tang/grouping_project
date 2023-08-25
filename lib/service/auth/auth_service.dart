import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grouping_project/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/service/auth/github_auth.dart';
import 'package:grouping_project/service/auth/google_auth.dart';

// flutter run --web-port 5000
class AuthService {
  final GoogleAuth _googleAuth = GoogleAuth();
  final GitHubAuth _gitHubAuth = GitHubAuth();

  Future signIn({required String account, required String password}) async {
    // AccountAuth accountAuth = AccountAuth();
    // await accountAuth.signIn(account: account, password: password);
    await PassToBackEnd.ToBabkend(
        provider: 'account', account: account, password: password);
  }

  Future signOut() async {}

  Future googleSignIn() async {
    try {
      if (kIsWeb) {
        await _googleAuth.signInWeb();
        await PassToBackEnd.ToBabkend(provider: 'google');
      } else if (Platform.isAndroid || Platform.isIOS) {
        throw UnimplementedError('Mobile platforms are current WIP');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future githubSignIn() async {
    try {
      if (kIsWeb) {
        await _gitHubAuth.signInWeb();
        await PassToBackEnd.ToBabkend(provider: 'github');
      } else if (Platform.isAndroid || Platform.isIOS) {
        throw UnimplementedError('Mobile platforms are current WIP');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future lineSignIn() async {
    // TODO: implement lineSignIn;
  }
}

class PassToBackEnd {
  static Future ToBabkend(
      {required String provider, String? account, String? password}) async {
    try {
      if (provider == 'account') {
        if (account == null) {
          throw Exception('Please enter account');
        }
        if (password == null) {
          throw Exception('Please enter password');
        }
      }
      Uri url;
      if (kIsWeb) {
        url = Uri.parse('${Config.baseUriWeb}/auth/$provider/');
      } else {
        url = Uri.parse('${Config.baseUriMobile}/auth/$provider/');
      }

      http.Response response = await http.post(
        url,
      );
      // debugPrint(response.body);
      if (response.statusCode != 200) {
        throw Exception(response.body);
      } else {
        const storage = FlutterSecureStorage();
        await storage.write(key: 'auth-provider', value: provider);
        await storage.write(key: 'auth-token', value: response.body);
        storage.readAll().then((value) => debugPrint(value.toString()));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
