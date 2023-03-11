import 'package:grouping_project/model/user_model.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

//For all service, you need an AuthService instance
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //kIsWeb => Web
  //Platform.isIos / Platform.isAndroid => IOS ? Android;
  // Change scopes parameter for different scope
  final GoogleSignIn _googleSignInWeb = GoogleSignIn(
    clientId:
        '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
    scopes: <String>['email'],
  );
  final GoogleSignIn _googleSignInIos = GoogleSignIn(
    clientId:
        '784990691438-q9ni6tteu6336u58fcdlf9opdm6cvtok.apps.googleusercontent.com',
    scopes: <String>['email'],
  );

  String _email = '';

  Stream<UserModel?> get onAuthStateChanged {
    return _auth
        .authStateChanges()
        .map((User? user) => _userModelFromAuth(user));
  }

  UserModel? _userModelFromAuth(User? user) {
    if (user != null) {
      print(user.uid);
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  String getUid() {
    String cur = _auth.currentUser!.uid;
    return cur;
  }

//These 3 func. are for two step Login/SignUp
//For using it, pass email and password in two step
  Future<void>? setEmail(String? email) {
    if (email != null) {
      _email = email;
    }
  }

  Future<void> setPassword(User user, String password) async {
    await user.updatePassword(password);
  }

//Login with email & password (with all the information)
  Future emailLogIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      _email = '';

      return _userModelFromAuth(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sing up with email & password (with all the information)
  Future emailSignUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      setPassword(user, user.uid);
      _email = '';

      return _userModelFromAuth(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel?> thridPartyLogin(String provider) async {
    switch (provider) {
      case "apple":
        //apple login
        break;
      case "google":
        return await googleLogin();
      case "gitub":
        //github login
        break;
      default:
    }
  }

//Google Login
  Future googleLogin() async {
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
        await _googleSignInWeb.signInSilently();
        GoogleSignInAccount? googleUser = await _googleSignInWeb.signIn();
        if (googleUser == null) {
          return false;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);
        if (result.user!.providerData[0].email != null) {
          setEmail(result.user!.providerData[0].email);
        }

        return _userModelFromAuth(result.user);
      }
      if (Platform.isIOS) {
        //var httpClient = (await _googleSignInIos.authenticatedClient())!;
        //var peopleApi = PeopleServiceApi(httpClient);
        //var email = peopleApi.people.get("people/me");
        GoogleSignInAccount? googleUser = await _googleSignInIos.signIn();
        if (googleUser == null) {
          return false;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);
        if (result.user!.providerData[0].email != null) {
          setEmail(result.user!.providerData[0].email);
        }

        return _userModelFromAuth(result.user);
      }
    } catch (e) {
      print(e);
    }
  }

//Google Log out
  Future<void> googleSignOut() async {
    if (kIsWeb) {
      _googleSignInWeb.disconnect();
    }
    if (Platform.isIOS) {
      await _googleSignInIos.disconnect();
    }
  }

//  Future signInAnon() async {
//    try {
//      UserCredential result = await _auth.signInAnonymously();
//      User? user = result.user;
//      return _userModelFromAuth(user);
//    } catch (e) {
//      return null;
//    }
//  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //a function determine a user is logging in for the first time or not.
  //if the user have logging before, return true; otherwise, return false.
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
