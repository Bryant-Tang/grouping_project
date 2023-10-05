import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/service/auth/github_auth.dart';
import 'package:grouping_project/service/auth/google_auth.dart';

// flutter run --web-port 5000
class AuthService {
  final GoogleAuth _googleAuth = GoogleAuth();
  final GitHubAuth _gitHubAuth = GitHubAuth();

  Future signUp(
      {required String account,
      required String password,
      String? username}) async {
    debugPrint(Platform.operatingSystem);
    try {
      await PassToBackEnd.toAuthBabkend(
          provider: 'account',
          account: account,
          password: password,
          username: username,
          register: true);
    } catch (e) {
      // debugPrint("In func. signUp: $e");
      rethrow;
    }
  }

  Future signIn({required String account, required String password}) async {
    // AccountAuth accountAuth = AccountAuth();
    // await accountAuth.signIn(account: account, password: password);
    debugPrint(Platform.operatingSystem);
    try {
      await PassToBackEnd.toAuthBabkend(
          provider: 'account',
          account: account,
          password: password,
          register: false);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future logOut() async {
    const storage = FlutterSecureStorage();

    await storage.delete(key: 'auth-provider');
    await storage.delete(key: 'auth-token');
    storage.readAll().then((value) => debugPrint(value.toString()));
  }

  Future thridPartyLogin(String name) async {
    switch (name) {
      case 'google':
        googleSignIn();
        break;
      case 'github':
        githubSignIn();
        break;
      case 'line':
        lineSignIn();
        break;
      default:
    }
  }

  Future googleSignIn() async {
    try {
      debugPrint(Platform.operatingSystem);
      if (kIsWeb) {
        await _googleAuth.signInWeb();
        await PassToBackEnd.toAuthBabkend(provider: 'google');
      } else if (Platform.isAndroid || Platform.isIOS) {
        await _googleAuth.signInMobile();
        await PassToBackEnd.toAuthBabkend(provider: 'google');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future githubSignIn() async {
    try {
      debugPrint(Platform.operatingSystem);
      await PassToBackEnd.toInformPlatform();
      if (kIsWeb) {
        await _gitHubAuth.signInWeb();
        await PassToBackEnd.toAuthBabkend(provider: 'github');
      } else if (Platform.isAndroid || Platform.isIOS) {
        await _gitHubAuth.signInMobile();
        await PassToBackEnd.toAuthBabkend(provider: 'github');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future lineSignIn() async {
    debugPrint(Platform.operatingSystem);
    // TODO: implement lineSignIn;
  }
}

class PassToBackEnd {
  static Future toInformPlatform() async {
    String stringUrl;
    if (kIsWeb) {
      stringUrl = '${Config.baseUri}/auth/platform/';
    } else {
      stringUrl = '${Config.baseUriMobile}/auth/platform/';
    }
    http.Response response = await http.post(Uri.parse(stringUrl),
        body: {'platform': kIsWeb ? 'web' : 'mobile'});
  }

  static Future toAuthBabkend(
      {required String provider,
      String? account,
      String? password,
      bool register = false,
      String? username}) async {
    Object body = {};
    try {
      Uri url;
      String stringUrl;
      if (kIsWeb) {
        stringUrl = '${Config.baseUri}/auth/$provider/';
      } else {
        stringUrl = '${Config.baseUriMobile}/auth/$provider/';
      }

      if (provider == 'account') {
        if (account == null) {
          throw Exception('Please enter account');
        }
        if (password == null) {
          throw Exception('Please enter password');
        }
        if (username != null && register == true) {
          body = {
            'account': account,
            'password': password,
            'username': username
          };
        } else {
          body = {'account': account, 'password': password};
        }
        if (register == true) {
          stringUrl += 'register/';
        } else {
          stringUrl += 'signin/';
        }
      }
      debugPrint(stringUrl);
      url = Uri.parse(stringUrl);

      http.Response response = await http.post(url, body: body);
      // debugPrint(response.body);
      if (response.statusCode == 401) {
        Map<String, dynamic> body = json.decode(response.body);
        throw AuthServiceException(
            code: body['error-code'], message: body['error']);
      } else if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();

        await storage.write(key: 'auth-provider', value: provider);
        await storage.write(key: 'auth-token', value: response.body);

        storage.readAll().then((value) => debugPrint(value.toString()));
      } else if (response.statusCode < 600 && response.statusCode > 499) {
        throw Exception('Server exception: code ${response.statusCode}');
      } else {
        throw Exception('reponses status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("In func. toAuthBabkend: $e");
      rethrow;
    }
  }
}
