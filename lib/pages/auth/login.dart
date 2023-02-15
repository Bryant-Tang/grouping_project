import 'dart:ffi';
import 'package:flutter/material.dart';
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
  LoginPage({Key? key}) : super(key: key);
  final headLineText = "登入 / 註冊";
  final content = "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務";
  final buttonUI = {
    "Apple": {"fileName": "apple.png", "name": "apple", "onPress": () {}},
    "Google": {"fileName": "google.png", "name": "google", "onPress": () {}},
    "Github": {"fileName": "github.png", "name": "github", "onPress": () {}},
  };
  List<Widget> buttonBuilder() {
    List<Widget> authButtonList = [];
    for (dynamic button in buttonUI.values) {
      authButtonList.add(AuthButton(
          fileName: button["fileName"],
          name: button["name"],
          onPressed: button["onPress"]));
    }
    return authButtonList;
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 100.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              HeadlineWithContent(
                  headLineText: widget.headLineText, content: widget.content),
              const SizedBox(height: 50),
              const EmailForm(),
              const SizedBox(height: 50),
              const HintTextWithLine(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(children: widget.buttonBuilder()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              print(value);
              if (value == "quan" || value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          MaterialButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );
              }
            },
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text(
              "Continue with email",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

// class EmailTextField extends StatefulWidget {
//   const EmailTextField({super.key});

//   @override
//   State<EmailTextField> createState() => _EmailTextFieldState();
// }

// class _EmailTextFieldState extends State<EmailTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.max,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//           child: TextFormField(),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//           child:
//         ),
//       ],
//     );
//   }
// }

class AuthButton extends StatelessWidget {
  final String fileName;
  final String name;
  final Void? Function() onPressed;
  const AuthButton({
    super.key,
    required this.fileName,
    required this.name,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: MaterialButton(
          onPressed: () {},
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset("assets/images/$fileName"),
                const SizedBox(width: 10),
                Text(
                  "${name.toUpperCase()} 帳號登入",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
}

class HeadlineWithContent extends StatelessWidget {
  final String headLineText;
  final String content;
  final TextStyle headLineStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Color(0Xff1E1E1E));
  final TextStyle contentStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0Xff717171));
  const HeadlineWithContent(
      {super.key, required this.headLineText, required this.content});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(headLineText, style: headLineStyle),
        Text(content, style: contentStyle),
      ],
    );
  }
}

class HintTextWithLine extends StatelessWidget {
  const HintTextWithLine({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
