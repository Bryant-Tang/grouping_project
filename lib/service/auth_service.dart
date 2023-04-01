import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grouping_project/model/user_model.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

/// For all auth service, you need an AuthService instance
///
/// For google login locol host,
/// flutter run --web-hostname localhost --web-port 5000
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserModel?> get onAuthStateChanged {
    return _auth
        .authStateChanges()
        .map((User? user) => _userModelFromAuth(user));
  }

  /// Change Auth User into UserModel
  UserModel? _userModelFromAuth(User? user) {
    if (user != null) {
      debugPrint("${user.uid}\n");
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  /// Returns the Uid of current user
  String getUid() {
    String cur = _auth.currentUser!.uid;
    return cur;
  }

  /// get thrid partt profile photo
  Future<XFile?> getProfilePicture() async {
    String? photoUrl = _auth.currentUser!.photoURL;
    if (photoUrl != null) {
      var file = await DefaultCacheManager().getSingleFile(photoUrl);
      XFile result = XFile(file.path);
      return result;
    } else {
      return null;
    }
  }

  Future<String?> getProfileName() async {
    String? name = _auth.currentUser!.displayName;
    return name;
  }

  /// Change the password of the target user
  Future<void> setPassword(User user, String password) async {
    await user.updatePassword(password);
  }

  /// Login with email & password
  ///
  /// return userModel if succeed., return error code if FireAuthException catched.
  ///
  /// Error codes are:
  /// * **invalid-email:**
  /// * Thrown if the email address is not valid.
  /// * **user-disabled:**
  /// * Thrown if the user corresponding to the given email has been disabled.
  /// * **user-not-found:**
  /// * Thrown if there is no user corresponding to the given email.
  /// * **wrong-password:**
  /// * Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
  Future emailLogIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      return _userModelFromAuth(user);
    } on FirebaseAuthException catch (error) {
      rethrow;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  /// sing up with email & password
  ///
  /// return userModel if succeed, return null if any error catched.
  ///
  /// Error codes are:
  /// * **email-already-in-use:**
  /// * Thrown if there already exists an account with the given email address.
  /// * **invalid-email:**
  /// * Thrown if the email address is not valid.
  /// * **operation-not-allowed:**
  /// * Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
  /// * **weak-password:**
  /// * Thrown if the password is not strong enough.
  Future emailSignUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      return _userModelFromAuth(user);
    } on FirebaseAuthException catch (error) {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Send login email link to target email address
  /// flutter run --web-hostname localhost --web-port 5000 for easy test
  ///
  /// ! onlu 5 mails a day !
  // Future<void> sendEmailLink(String email) async {
  //   try {
  //     ActionCodeSettings actionCodeSettings = ActionCodeSettings(
  //         url: "https://127.0.0.1:5000/#/", handleCodeInApp: true);
  //     _auth.sendSignInLinkToEmail(
  //         email: email, actionCodeSettings: actionCodeSettings);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  /// To handle the email link
  // void handleEmailLink() {}

  /// Thrid party login with provider name as parameter
  ///
  /// return UserModel if succeed, return null if provier not suported of implemented.
  Future<UserModel?> thridPartyLogin(String provider) async {
    switch (provider) {
      case "google":
        UserModel? googleUser = await googleLogin();
        return googleUser;
      case "facebook":
        await facebookLogin();
        break;
      case "github":
        break;
      default:
        return null;
    }
  }

  // now at step 6
  Future<UserModel?> facebookLogin() async {}

  /// Google Login
  /// return UserModel if succeed, no return if failed
  Future<UserModel?> googleLogin() async {
    bool kisweb;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        kisweb = false;
      } else {
        kisweb = true;
      }
    } catch (e) {
      kisweb = true;
    }
    try {
      if (kisweb) {
        //var httpClient = (await _googleSignInWeb.authenticatedClient())!;
        //var peopleApi = PeopleServiceApi(httpClient);
        //var email = peopleApi.people.get("people/me");
        final GoogleSignIn _googleSignInWeb = GoogleSignIn(
          clientId:
              '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
          scopes: <String>['email'],
        );
        await _googleSignInWeb.signInSilently();
        GoogleSignInAccount? googleUser = await _googleSignInWeb.signIn();
        if (googleUser == null) {
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);

        return _userModelFromAuth(result.user);
      }
      if (Platform.isIOS) {
        //var httpClient = (await _googleSignInIos.authenticatedClient())!;
        //var peopleApi = PeopleServiceApi(httpClient);
        //var email = peopleApi.people.get("people/me");
        final GoogleSignIn _googleSignInIos = GoogleSignIn(
          clientId:
              '784990691438-q9ni6tteu6336u58fcdlf9opdm6cvtok.apps.googleusercontent.com',
          scopes: <String>['email'],
        );
        GoogleSignInAccount? googleUser = await _googleSignInIos.signIn();
        if (googleUser == null) {
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);

        return _userModelFromAuth(result.user);
      }
      if (Platform.isAndroid) {
        //var httpClient = (await _googleSignInIos.authenticatedClient())!;
        //var peopleApi = PeopleServiceApi(httpClient);
        //var email = peopleApi.people.get("people/me");
        final GoogleSignIn _googleSignInAndroid = GoogleSignIn(
          // serverClientId:
          //     '784990691438-vutrcfkafr5d4eaq0tio9q36bl72bvae.apps.googleusercontent.com',
          serverClientId:
              '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
          scopes: <String>['email'],
        );
        GoogleSignInAccount? googleUser = await _googleSignInAndroid.signIn();
        if (googleUser == null) {
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);

        return _userModelFromAuth(result.user);
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Google Log out, no return
  Future<void> googleSignOut() async {
    if (kIsWeb) {
      GoogleSignIn(
        clientId:
            '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
        scopes: <String>['email'],
      ).disconnect();
    }
    if (Platform.isIOS) {
      await GoogleSignIn(
        clientId:
            '784990691438-q9ni6tteu6336u58fcdlf9opdm6cvtok.apps.googleusercontent.com',
        scopes: <String>['email'],
      ).disconnect();
    }
    if (Platform.isAndroid) {
      GoogleSignIn(
        // serverClientId:
        //     '784990691438-vutrcfkafr5d4eaq0tio9q36bl72bvae.apps.googleusercontent.com',
        serverClientId:
            '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
        scopes: <String>['email'],
      ).disconnect();
    }
  }

  /// Email sign out, no return
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// a function determine a user is logging in for the first time or not.
  ///
  /// if the user have logging before, return true; otherwise, return false.
  Future<bool> haveEverLoginBefore(String userId) async {
    final clientLocation =
        FirebaseFirestore.instance.collection('client_properties').doc(userId);
    bool ans = false;
    await clientLocation.get().then(
      (DocumentSnapshot doc) {
        ans = true;
      },
      onError: (e) {
        debugPrint(
            '[Notification] this client is logging in for the first time.');
        ans = false;
      },
    );
    return ans;
  }
}
