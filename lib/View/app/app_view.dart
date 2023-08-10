import 'package:flutter/material.dart';
import 'package:googleapis/adsense/v2.dart';
import 'package:grouping_project/service/auth/github_auth.dart';
// For end-to-end testing
import 'package:grouping_project/service/auth/google_auth.dart';
import 'package:grouping_project/service/auth/account_auth.dart';
//

class AppView extends StatelessWidget {
  AppView({Key? key}) : super(key: key);
  AccountAuth accountAuth = AccountAuth();
  GoogleAuth googleAuth = GoogleAuth();
  GitHubAuth gitHubAuth = GitHubAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await googleAuth.signIn();
              },
              child: const Text('Sign in with Google'),
            ),
            TextFormField(
              onChanged: (value) => accountAuth.account = value,
            ),
            TextFormField(
              onChanged: (value) => accountAuth.password = value,
            ),
            ElevatedButton(
              onPressed: () async {
                await accountAuth.signIn();
              },
              child: const Text('Sign in with Account'),
            ),
            ElevatedButton(
                onPressed: () async {
                  await gitHubAuth.signIn();
                },
                child: const Text('Sign in with GitHub'))
          ],
        ),
      ),
    );
  }
}
