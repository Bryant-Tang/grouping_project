import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
// For end-to-end testing

//

class AppView extends StatelessWidget{
  const AppView({Key? key}) : super(key: key);
  // TODO: check login state
  final bool isLogin = false;
  
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return const Scaffold(
        body: Text('Dashboard Page'),
      );
    }
    else{
      return const AuthView();
    }
  }
}

// class AppView extends StatelessWidget {
//   AppView({Key? key}) : super(key: key);
//   AuthService authService = AuthService();
//   late String account;
//   late String password;
//   Uri? Url;

//   @override
//   Widget build(BuildContext context) {
//     String provider = '';
//     const storage = FlutterSecureStorage();
//     storage.read(key: 'auth-provider').then((value) => provider = value ?? '');
//     if (provider == '') {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   await authService.googleSignIn();
//                 },
//                 child: const Text('Sign in with Google'),
//               ),
//               TextFormField(
//                 onChanged: (value) => account = value,
//               ),
//               TextFormField(
//                 onChanged: (value) => password = value,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await authService.signIn(
//                       account: account, password: password);
//                 },
//                 child: const Text('Sign in with Account'),
//               ),
//               ElevatedButton(
//                   onPressed: () async {
//                     await authService.githubSignIn();
//                   },
//                   child: const Text('Sign in with GitHub')),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return const Scaffold(
//         body: Text('Currently logging'),
//       );
//     }
//   }
// }
