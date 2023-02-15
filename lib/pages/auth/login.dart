import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:grouping_project/pages/auth/cover.dart';
// import 'package:grouping_project/pages/home/home_page.dart';
// import 'package:grouping_project/service/auth_service.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
// class _LoginPageState extends State<LoginPage> {
//   final AuthService _authService = AuthService();
//   String error = '';
//   String email = '';
//   String password = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0.0,
//           title: const Text('Sign in to Test'),
//           actions: <Widget>[
//             IconButton(
//               onPressed: () => Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => new CoverPage())),
//               icon: Icon(
//                 Icons.logout_outlined,
//               ),
//             )
//           ],
//         ),
//         body: Column(
//           children: <Widget>[
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(50.0),
//                             borderSide: BorderSide(
//                                 width: 4,
//                                 color: Color.fromARGB(255, 133, 168, 196)))),
//                     validator: (value) =>
//                         value!.isEmpty ? 'Enter your email' : null,
//                     onChanged: (value) {
//                       setState(() {
//                         email = value;
//                       });
//                     },
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                         labelText: 'Password',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(50.0),
//                           borderSide: BorderSide(
//                             width: 4,
//                             color: Color.fromARGB(255, 133, 168, 196),
//                           ),
//                         )),
//                     validator: (value) => value!.length < 6
//                         ? 'Enter password longer than 5'
//                         : null,
//                     onChanged: (value) {
//                       setState(() {
//                         password = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 50.0),
//               child: ElevatedButton(
//                 child: Text(
//                   "Email sign in",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () async {
//                   dynamic result =
//                       await _authService.emailLogIn(email, password);
//                   if (result != null) {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => new MyHomePage()));
//                   }
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 50.0),
//               child: TextButton.icon(
//                 label: Text("Gmail"),
//                 icon: Icon(
//                   Icons.account_circle_outlined,
//                 ),
//                 onPressed: () async {
//                   dynamic result = await _authService.googleLogin();
//                   if (result != null) {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => new MyHomePage()));
//                   }
//                 },
//               ),
//             )
//           ],
//         ));
//   }
// }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 30),
          child: Column(
            children: <Widget>[
              const SizedBox(
                // head line
                width: double.infinity,
                child: Text(
                  "登入 / 註冊",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0Xff1E1E1E)),
                ),
              ),
              const SizedBox(
                // content
                width: double.infinity,
                child: Text(
                  "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0Xff717171)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            label: Text("EMAIL / 電子郵件",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            prefix: Icon(Icons.email),
                            constraints: BoxConstraints(maxHeight: 45)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: MaterialButton(
                          onPressed: () {},
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.amber, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Text(
                            "Continue with email",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff707070),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Text(
                        "OR CONNECT WITH",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 12,
                          fontFamily: "Noto Sans TC",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff707070),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: const <Widget>[
                      LogoButton(),
                      LogoButton(),
                      LogoButton(),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class LogoButton extends StatefulWidget {
  const LogoButton({Key? key}) : super(key: key);

  @override
  _LogoButtonState createState() => _LogoButtonState();
}

// TODO
// pass the name / icon parameters
// make the layout prettier
class _LogoButtonState extends State<LogoButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: MaterialButton(
          onPressed: () {},
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Icon(Icons.question_mark),
              SizedBox(width: 10),
              Text(
                "Login with google account",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}
