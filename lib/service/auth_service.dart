import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
    scopes: <String>['email'],
  );

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

//sing in with email & password
  Future emailLogIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      return _userModelFromAuth(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future emailSignUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      return _userModelFromAuth(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future googleLogin() async {
    try {
      return _userModelFromGAuth(await _googleSignIn.signIn());
    } catch (e) {
      print(e);
    }
  }

  Future<void> googleSignOut() async {
    _googleSignIn.disconnect();
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userModelFromAuth(user);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
