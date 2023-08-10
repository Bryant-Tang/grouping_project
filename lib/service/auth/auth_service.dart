import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Used to authenticate to our backend
class AuthWithBackEndService {
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

    debugPrint(response.body);
  }

  /// When debugging on web, you need to run the backend on localhost:5000
  ///
  /// flutter run --web-hostname localhost --web-port 5000
  static Future authWithGoogle(String idToken) async {
    debugPrint('authWithGoogle: $idToken');

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

    debugPrint(response.body);
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
