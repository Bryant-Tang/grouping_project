import 'package:flutter/material.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
import 'package:grouping_project/service/auth/github_auth.dart';
// For end-to-end testing

//

class AppView extends StatelessWidget {
  AppView({Key? key, required this.queryParameters}) : super(key: key);
  AuthService authService = AuthService();
  late String account;
  late String password;
  final Map<String, String> queryParameters;
  Uri? Url;

  @override
  Widget build(BuildContext context) {
    if (queryParameters.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await authService.googleSignIn();
                },
                child: const Text('Sign in with Google'),
              ),
              TextFormField(
                onChanged: (value) => account = value,
              ),
              TextFormField(
                onChanged: (value) => password = value,
              ),
              ElevatedButton(
                onPressed: () async {
                  await authService.signIn(
                      account: account, password: password);
                },
                child: const Text('Sign in with Account'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await authService.githubSignIn();
                  },
                  child: const Text('Sign in with GitHub'))
            ],
          ),
        ),
      );
    } else {
      GitHubAuth gitHubAuth = GitHubAuth();
      gitHubAuth.signInWebOnCallback(queryParameters!);
      return Scaffold(
        body: Center(
          child: Text("queryParameters: $queryParameters"),
        ),
      );
    }
  }
}
