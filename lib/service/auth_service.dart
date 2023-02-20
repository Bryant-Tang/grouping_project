import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:grouping_project/model/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

//For all service, you need an AuthService instance
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
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
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  UserModel? _userModelFromGAuth(GoogleSignInAccount? user) {
    if (user != null) {
      return UserModel(uid: user.id);
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
  Future<void> setEmail(String email) async {
    _email = email;
  }

  Future<void> setPassword(User user, String password) async {
    await user.updatePassword(password);
  }

  Future<void> sendCode(String code) async {
    print(_email);
    final Email email = Email(
      body:
          'Hello!\nPlease enter following code for your email login:\n{$code}\nIf you didn’t ask to login, you can ignore this email.\nThanks,\nYour Grouping team',
      subject: 'Login code for GROUPING!',
      recipients: [_email],
      cc: [''],
      bcc: [''],
      attachmentPaths: [''],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
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

//Google Login
  Future googleLogin() async {
    try {
      return _userModelFromGAuth(await _googleSignIn.signIn());
    } catch (e) {
      print(e);
    }
  }

//Google Log out
  Future<void> googleSignOut() async {
    _googleSignIn.disconnect();
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
