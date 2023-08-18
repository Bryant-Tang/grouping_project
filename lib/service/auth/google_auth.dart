import "dart:io";

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

class GoogleAuth {
  bool isLoading = false;

  Future<GoogleSignIn> _getCorrectGoogleSignIn() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      return GoogleSignIn(
        clientId: dotenv.env['GOOGLE_CLIENT_ID_WEB'],
        scopes: <String>['email'],
      );
    } else if (Platform.isAndroid) {
      return GoogleSignIn(
        // serverClientId:
        //     '784990691438-vutrcfkafr5d4eaq0tio9q36bl72bvae.apps.googleusercontent.com',
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID_ANDROID'],
        scopes: <String>['email'],
      );
    } else if (Platform.isIOS) {
      return GoogleSignIn(
        clientId: dotenv.env['GOOGLE_CLIENT_ID_IOS'],
        scopes: <String>['email'],
      );
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future signIn() async {
    final googleSignIn = await _getCorrectGoogleSignIn();
    try {
      isLoading = true;
      if (kIsWeb) {
        GoogleSignInAccount? googleUser =
            await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
        googleUser = await googleSignIn.signInSilently();

        if (googleUser == null) {
          throw Exception('Google Sign In Failed');
        }

        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        if (googleAuth.idToken == null) {
          throw Exception('Google Sign In Failed');
        }

        AuthWithBackEndService.authWithGoogle(googleAuth.idToken!);
      } else if (Platform.isAndroid || Platform.isIOS) {
        GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        if (googleAuth.idToken == null) {
          throw Exception('Google Sign In Failed');
        }

        AuthWithBackEndService.authWithGoogle(googleAuth.idToken!);
      } else {
        isLoading = false;
        throw Exception('Unsupported platform');
      }
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
    isLoading = false;
  }
}
