import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/user_model.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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

  /// return custom user model, only for backend
  UserModel? _userModelFromAuth(User? user) {
    if (user != null) {
      debugPrint('Uid is ${user.uid}');
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

  /// get thrid party account profile including email, name, photo
  ///
  /// return ProfileModel if logged in, return null if not
  Future<ProfileModel?> getProfile() async {
    User? user = _auth.currentUser;
    File? photoFile;
    if (user == null) {
      return null;
    }
    if (user.photoURL != null && !kIsWeb) {
      photoFile = File('${(await getTemporaryDirectory()).path}/temp-photo');
      // debugPrint(user.photoURL);
      http.Response response = await http.get(Uri.parse(user.photoURL!));
      debugPrint('response code: ${response.statusCode.toString()}');

      await photoFile.writeAsBytes(response.bodyBytes);
    }
    // debugPrint(
    //     '${user.displayName} ${user.providerData[0].email} ${user.photoURL}');
    return ProfileModel(
        name: user.displayName,
        nickname: user.displayName,
        email: user.providerData[0].email,
        photo: photoFile);
  }

  /// get correct googlesignin depend on platform
  /// return GoogleSignIn, only for backend
  GoogleSignIn? getCorrectGoogleSignIn() {
    if (kIsWeb) {
      return GoogleSignIn(
        clientId:
            '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
        scopes: <String>['email'],
      );
    } else if (Platform.isAndroid) {
      return GoogleSignIn(
        // serverClientId:
        //     '784990691438-vutrcfkafr5d4eaq0tio9q36bl72bvae.apps.googleusercontent.com',
        serverClientId:
            '784990691438-2raup8q9qutdb9cc4fq1cpg6ntffm0be.apps.googleusercontent.com',
        scopes: <String>['email'],
      );
    } else if (Platform.isIOS) {
      return GoogleSignIn(
        clientId:
            '784990691438-q9ni6tteu6336u58fcdlf9opdm6cvtok.apps.googleusercontent.com',
        scopes: <String>['email'],
      );
    }
  }

  /// When logged in to a google-existed account
  /// This well login and link to current-login-method account
  // Future<UserModel?> linkWithGoogle(AuthCredential credential) async {
  //   try {
  //     await googleLogin(linkToFacebook: false).then((value) async {
  //       if ((value != null) &&
  //           (await FirebaseAuth.instance.fetchSignInMethodsForEmail(
  //                       FirebaseAuth.instance.currentUser!.email!))
  //                   .contains(credential.providerId) !=
  //               true) {
  //         debugPrint(
  //             'This place should be false: ${(await FirebaseAuth.instance.fetchSignInMethodsForEmail(FirebaseAuth.instance.currentUser!.email!)).contains(credential.providerId)}');
  //         await FirebaseAuth.instance.currentUser
  //             ?.linkWithCredential(credential);
  //       } else if (value != null) {
  //         return value;
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint('In the linking with google: ${e.toString()}');
  //   }
  // }

  /// When logged in to a facebook-existed account
  /// This well login and link to current-login-method account
  // Future<UserModel?> linkWithFacebook(AuthCredential credential) async {
  //   try {
  //     await facebookLogin(linkToGoogle: false).then((value) async {
  //       if ((value != null) &&
  //           (await FirebaseAuth.instance.fetchSignInMethodsForEmail(
  //                       FirebaseAuth.instance.currentUser!.email!))
  //                   .contains(credential.providerId) !=
  //               true) {
  //         debugPrint(
  //             'This place should be false: ${(await FirebaseAuth.instance.fetchSignInMethodsForEmail(FirebaseAuth.instance.currentUser!.email!)).contains(credential.providerId)}');
  //         await FirebaseAuth.instance.currentUser
  //             ?.linkWithCredential(credential);
  //       } else if (value != null) {
  //         return value;
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint('In the linking with facebook: ${e.toString()}');
  //   }
  // }

  /// When logged in to a github-existed account
  /// This well login and link to current-login-method account
  // Future<void> linkWithGitHub(AuthCredential credential) async {
  //   try {
  //     await githubLogin().then((value) async {
  //       debugPrint('=================link to github==================');
  //       if ((await FirebaseAuth.instance.fetchSignInMethodsForEmail(
  //                   FirebaseAuth.instance.currentUser!.email!))
  //               .contains(credential.providerId) !=
  //           true) {
  //         debugPrint((await FirebaseAuth.instance.fetchSignInMethodsForEmail(
  //                 FirebaseAuth.instance.currentUser!.email!))
  //             .contains(credential.providerId)
  //             .toString());
  //         await FirebaseAuth.instance.currentUser
  //             ?.linkWithCredential(credential);
  //         debugPrint(
  //             FirebaseAuth.instance.currentUser!.providerData.toString());
  //       }
  //       await signOut();
  //     });
  //   } catch (e) {
  //     debugPrint('In linking trys: ${e.toString()}');
  //     return;
  //   }
  // }

  /// Change the password of the target user
  Future<void> setPassword(User user, String password) async {
    await user.updatePassword(password);
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
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
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
    } on FirebaseAuthException {
      rethrow;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  /// Sign out from current user and disconnect current google user
  Future signOut() async {
    try {
      await _auth.signOut();
      getCorrectGoogleSignIn()?.disconnect();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Thrid party login with provider name as parameter
  ///
  /// return UserModel if succeed, return null if provier not suported of implemented.
  Future<UserModel?> thridPartyLogin(String provider) async {
    switch (provider) {
      case "google":
        UserModel? googleUser = await googleLogin();
        // debugPrint(googleUser.toString());
        return googleUser;
      case "facebook":
        UserModel? facebookUser = await facebookLogin();
        // debugPrint(facebookUser.toString());
        return facebookUser;
      case "github":
        UserModel? githubUser = await githubLogin();
        // debugPrint(githubUser.toString());
        return githubUser;
      default:
        return null;
    }
  }

  /// Facebook login
  ///
  /// return UserModel if succeed, return null if any error catched.
  Future<UserModel?> facebookLogin() async {
    debugPrint('========> Entered Facebook Login');
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
    if (kisweb) {
      await FacebookAuth.instance.webAndDesktopInitialize(
        appId: "520671110044862",
        cookie: true,
        xfbml: true,
        version: "v14.0",
      );
      // debugPrint(
      //     'There ${FirebaseAuth.instance.currentUser != null ? 'are' : 'isn\'t'} current user');

      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.status == LoginStatus.success) {
          final AuthCredential credential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);

          // if (linkToGithub == true) {
          //   debugPrint('+++++++++++++++> Tried link with Github');
          //   await linkWithGitHub(credential);
          // }
          // if (linkToGoogle == true) {
          //   try {
          //     await linkWithGoogle(credential).then((value) {
          //       if (value != null) {
          //         return value;
          //       }
          //     });
          //   } catch (e) {
          //     debugPrint('In linking with google: ${e.toString()}');
          //   }
          // }

          UserCredential result =
              await FirebaseAuth.instance.signInWithCredential(credential);
          if (result.additionalUserInfo?.isNewUser == true) {
            await DataController().createUser(
                userProfile:
                    await getProfile() ?? ProfileModel(nickname: 'unknown'));
          }
          return _userModelFromAuth(result.user);
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(e.code);
        // if (e.code == 'account-exists-with-different-credential') {
        //   return await facebookLogin(linkToGoogle: true);
        // }
      } catch (e) {
        debugPrint('In facebook login web: ${e.toString()}');
      }

      // FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      // facebookProvider.addScope('email');
      // facebookProvider.addScope('public_profile');
      // facebookProvider.setCustomParameters({
      //   'display': 'popup',
      // });

      // try {
      //   if (googleLink == true) {
      //     await FirebaseAuth.instance.currentUser
      //         ?.linkWithCredential(FacebookAuthProvider.credential(accessToken));
      //     await signOut();
      //   }
      //   await FirebaseAuth.instance
      //       .signInWithPopup(facebookProvider)
      //       .then((value) {
      //     debugPrint(value.toString());
      //     return _userModelFromAuth(value.user);
      //   });
      // } catch (error) {
      //   debugPrint('========> ${error.toString()}');
      // }

      // Once signed in, return the UserCredential
    } else if (Platform.isAndroid || Platform.isIOS) {
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.status == LoginStatus.success) {
          final AuthCredential credential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);

          // if (linkToGoogle == true) {
          //   try {
          //     await linkWithGoogle(credential).then((value) {
          //       if (value != null) {
          //         return value;
          //       }
          //     });
          //   } catch (e) {
          //     debugPrint('In link with google: ${e.toString()}');
          //   }
          // }
          // if (linkToGithub == true) {
          //   await linkWithGitHub(credential);
          // }

          UserCredential result =
              await FirebaseAuth.instance.signInWithCredential(credential);
          if (result.additionalUserInfo?.isNewUser == true) {
            await DataController().createUser(
                userProfile:
                    await getProfile() ?? ProfileModel(nickname: 'unknown'));
          }
          return _userModelFromAuth(result.user);
        }
      } catch (e) {
        debugPrint('In facebook login Android/Ios: ${e.toString()}');
      }
    }
  }

  /// Github login
  ///
  /// return UserModel if succeed, return null if any error catched.
  Future<UserModel?> githubLogin() async {
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
      GithubAuthProvider githubProvider = GithubAuthProvider();
      // AuthCredential authCredential =
      //     GithubAuthProvider.credential();
      // if (toLink == true) {
      //   linkWithFacebook(credential);
      //   linkWithGoogle(credential);
      // }

      if (kIsWeb) {
        UserCredential result =
            await FirebaseAuth.instance.signInWithPopup(githubProvider);
        if (result.additionalUserInfo?.isNewUser == true) {
          await DataController().createUser(
              userProfile:
                  await getProfile() ?? ProfileModel(nickname: 'unknown'));
        }

        return _userModelFromAuth(result.user);
      } else if (Platform.isAndroid || Platform.isIOS) {
        UserCredential result =
            await FirebaseAuth.instance.signInWithProvider(githubProvider);
        if (result.additionalUserInfo?.isNewUser == true) {
          await DataController().createUser(
              userProfile:
                  await getProfile() ?? ProfileModel(nickname: 'unknown'));
        }

        return _userModelFromAuth(result.user);
      }
    } catch (e) {
      debugPrint('In github login: ${e.toString()}');
    }
  }

  /// Google Login
  ///
  /// return UserModel if succeed, return null if any error catched.
  Future<UserModel?> googleLogin() async {
    debugPrint('========> Entered Google Login');
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
        final GoogleSignIn _googleSignInWeb = getCorrectGoogleSignIn()!;
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

        // if (linkToFacebook == true) {
        //   try {
        //     await linkWithFacebook(credential).then((value) {
        //       if (value != null) {
        //         return value;
        //       }
        //     });
        //   } catch (e) {
        //     debugPrint('In link with Facebook: ${e.toString()}');
        //   }
        // }
        // if (linkToGithub == true) {
        //   await linkWithGitHub(credential);
        // }

        UserCredential result = await _auth.signInWithCredential(credential);
        if (result.additionalUserInfo?.isNewUser == true) {
          await DataController().createUser(
              userProfile:
                  await getProfile() ?? ProfileModel(nickname: 'unknown'));
        }

        return _userModelFromAuth(result.user);
      }
      if (Platform.isIOS || Platform.isAndroid) {
        final GoogleSignIn _googleSignIn = getCorrectGoogleSignIn()!;
        GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // if (linkToFacebook == true) {
        //   try {
        //     await linkWithFacebook(credential).then((value) {
        //       if (value != null) {
        //         return value;
        //       }
        //     });
        //   } catch (e) {
        //     debugPrint('In link with Facebook: ${e.toString()}');
        //   }
        // }
        // if (linkToGithub == true) {
        //   await linkWithGitHub(credential);
        // }

        UserCredential result = await _auth.signInWithCredential(credential);
        if (result.additionalUserInfo?.isNewUser == true) {
          await DataController().createUser(
              userProfile:
                  await getProfile() ?? ProfileModel(nickname: 'unknown'));
        }

        return _userModelFromAuth(result.user);
      }
    } catch (e) {
      debugPrint('In google login${e.toString()}');
      return null;
    }
  }
}
