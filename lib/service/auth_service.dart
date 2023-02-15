import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

//For all service, you need an AuthService instance
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
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

//These 3 func. are for two step Login/SignUp
//For using it, pass email and password in two step
  Future<void>? setEmail(String email) {
    _email = email;
  }

//This is for SignUp
  Future<void>? setPassword(String password) {
    emailSignUp(_email, password);
  }

//This is for login
  Future<void>? varifyPassword(String password) {
    emailLogIn(_email, password);
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
      user.sendEmailVerification();
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
}
