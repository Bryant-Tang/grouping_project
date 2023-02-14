import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouping_project/pages/auth/cover.dart';
import 'package:grouping_project/pages/home/home.dart';
import 'package:grouping_project/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  String error = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 130, horizontal: 30),
          )
      )
    );
    // y: Column(
    //   children: <Widget>[
    //     Padding(
    //       padding:
    //           const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    //       child: Column(
    //         children: [
    //           TextFormField(
    //             decoration: InputDecoration(
    //                 labelText: 'Email',
    //                 border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(50.0),
    //                     borderSide: BorderSide(
    //                         width: 4,
    //                         color: Color.fromARGB(255, 133, 168, 196)))),
    //             validator: (value) =>
    //                 value!.isEmpty ? 'Enter your email' : null,
    //             onChanged: (value) {
    //               setState(() {
    //                 email = value;
    //               });
    //             },
    //           ),
    //           TextFormField(
    //             decoration: InputDecoration(
    //                 labelText: 'Password',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(50.0),
    //                   borderSide: BorderSide(
    //                     width: 4,
    //                     color: Color.fromARGB(255, 133, 168, 196),
    //                   ),
    //                 )),
    //             validator: (value) => value!.length < 6
    //                 ? 'Enter password longer than 5'
    //                 : null,
    //             onChanged: (value) {
    //               setState(() {
    //                 password = value;
    //               });
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 50.0),
    //       child: ElevatedButton(
    //         child: Text(
    //           "Email sign in",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         onPressed: () async {
    //           dynamic result = _authService.emailLogIn(email, password);
    //           if (result != null) {
    //             Navigator.pushReplacement(context,
    //                 MaterialPageRoute(builder: (context) => new Home()));
    //           }
    //         },
    //       ),
    //     ),
    //   ],
  }
}
