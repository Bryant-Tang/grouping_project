import 'package:flutter/material.dart';
import 'package:grouping_project/pages/auth/cover.dart';
import 'package:grouping_project/service/auth_service.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gurupin'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(
              Icons.logout_outlined,
            ),
            style: TextButton.styleFrom(
              iconColor: Color.fromARGB(255, 255, 255, 255),
            ),
            label: Text('Sign out'),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => new CoverPage()));
            },
          )
        ],
      ),
    );
  }
}
