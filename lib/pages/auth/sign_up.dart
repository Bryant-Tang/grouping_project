import 'package:grouping_project/pages/auth/cover.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  // bool loading = false;
  final AuthService _authService = AuthService();

  // String error = '';
  // String email = '';
  // String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // appBar: AppBar(
    //   elevation: 0.0,
    //   title: const Text('Sign up to test'),
    //   actions: <Widget>[
    //     IconButton(
    //       onPressed: () => Navigator.pushReplacement(context,
    //           MaterialPageRoute(builder: (context) => new CoverPage())),
    //       icon: Icon(
    //         Icons.logout_outlined,
    //       ),
    //     )
    //   ],
    // ),
    // body: Column(
    //   children: <Widget>[
    //     Padding(
    //       padding:
    //           const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    //       child: Form(
    //           key: _formKey,
    //           child: Column(
    //             children: [
    //               TextFormField(
    //                 decoration: InputDecoration(
    //                     labelText: 'Email',
    //                     border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(50.0),
    //                         borderSide: BorderSide(
    //                             width: 4,
    //                             color:
    //                                 Color.fromARGB(255, 133, 168, 196)))),
    //                 validator: (value) {
    //                   if (value!.isEmpty || value == null) {
    //                     return 'please enter email';
    //                   } else {
    //                     return null;
    //                   }
    //                 },
    //                 onChanged: (value) {
    //                   setState(() {
    //                     email = value;
    //                   });
    //                 },
    //               ),
    //               TextFormField(
    //                 decoration: InputDecoration(
    //                     labelText: 'Password',
    //                     border: OutlineInputBorder(
    //                       borderRadius: BorderRadius.circular(50.0),
    //                       borderSide: BorderSide(
    //                         width: 4,
    //                         color: Color.fromARGB(255, 133, 168, 196),
    //                       ),
    //                     )),
    //                 validator: (value) => value!.length < 6
    //                     ? 'Enter password longer than 5'
    //                     : null,
    //                 onChanged: (value) {
    //                   setState(() {
    //                     password = value;
    //                   });
    //                 },
    //               ),
    //             ],
    //           )),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 50.0),
    //       child: ElevatedButton(
    //         child: Text(
    //           "Email sign up",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         onPressed: () {
    //           if (_formKey.currentState!.validate()) {
    //             setState(() => loading = true);
    //             dynamic result = _authService.emailSignUp(email, password);
    //             if (result == null) {
    //               setState(() {
    //                 error = 'Please provide a valid email';
    //                 loading = false;
    //               });
    //             } else {
    //               Navigator.pushReplacement(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => new MyHomePage()));
    //             }
    //           }
    //         },
    //       ),
    //     ),
    //   ],
    // ));
  }
}
