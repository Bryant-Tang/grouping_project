import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/web_login_view.dart';
import 'package:grouping_project/View/app/auth/web_sign_in_view.dart';
import 'package:grouping_project/View/theme/theme.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key, this.mode = 'login'});
  final String mode;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (mode == 'login') {
        return const WebLoginView();
      } else if (mode == 'signIn') {
        return const WebSignInView();
      } else {
        return const WebLoginView();
      }
      // return const WebSignInView();
    } else {
      return Scaffold(
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AuthService authService = AuthService();
                authService.googleSignIn();
              },
              child: Text("Login With google"),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService authService = AuthService();
                authService.githubSignIn(context);
              },
              child: Text("Login With Github"),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService authService = AuthService();
                authService.lineSignIn(context);
              },
              child: Text("Login With Line"),
            ),
          ],
        )),
      );
    }
  }
}

class AuthViewFrame extends StatelessWidget {
  final Widget? child;
  const AuthViewFrame({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppPadding.object(
          child: Container(
              width: 750,
              decoration: BoxDecoration(
                  color: AppColor.surface(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.primary(context).withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 0))
                  ]),
              child: AspectRatio(
                aspectRatio: 1.3,
                child: child ?? const SizedBox.shrink(),
              ))),
    );
  }
}

class BackGroundContainer extends StatelessWidget {
  final Widget? child;
  const BackGroundContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: AppColor.surface(context),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                AppColor.surface(context).withOpacity(0.95), BlendMode.screen),
            image: const AssetImage('assets/images/cover.png'),
            fit: BoxFit.values[4]),
      ),
      child: child ?? const SizedBox.expand(),
    );
  }
}

class TitleWithContent extends StatelessWidget {
  final String title;
  final String content;
  const TitleWithContent(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.titleLarge(context)),
        Text(content,
            style: AppText.titleSmall(context)
                .copyWith(color: AppColor.onSurface(context).withOpacity(0.5))),
      ],
    );
  }
}

final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.amber,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
