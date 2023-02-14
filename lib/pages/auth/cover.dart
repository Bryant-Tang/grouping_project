import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouping_project/pages/auth/login.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';

class CoverPage extends StatelessWidget {
  const CoverPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: const AssetImage("assets/images/cover.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.1), BlendMode.modulate))),
      child: Column(
        children: [
          const SizedBox(width: 10, height: 315),
          SvgPicture.asset(
            "assets/images/logo.svg",
            semanticsLabel: 'Acme Logo',
          ),
          const SizedBox(width: 10, height: 210),
          Column(
            children: [
              PhysicalModel(
                color: Colors.black12.withOpacity(0.0),
                shadowColor: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                elevation: 8.0,
                child: MaterialButton(
                  color: Colors.amber,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                    child: Text(
                      "已經有帳號了 Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NotoSansTC",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              PhysicalModel(
                color: Colors.black12.withOpacity(0.0),
                shadowColor: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                elevation: 8.0,
                child: MaterialButton(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    //side: BorderSide(width: 1, color: Color(0xFF979797),),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => new SignUp()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 5.0),
                    child: Text(
                      "還沒有帳號 Sign Up",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: "NotoSansTC",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
