

import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';
import 'package:grouping_project/View/theme/color.dart';
import 'package:grouping_project/View/theme/padding.dart';

class WelcomeView extends StatelessWidget{
  WelcomeView({Key? key}) : super(key: key);

  final textFormKey = GlobalKey<FormState>();

  final inputFieldBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gapPadding: 10
  );

  @override
  Widget build(BuildContext context) {
    Widget loginFrame = Center(
      child: AppPadding.large(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWithContent(
              title: "張百寬, 您好\n歡迎加入 GROUPING！", 
              content: "趕快加入或創立新的工作小組吧。"
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                  if(textFormKey.currentState!.validate()){
                    debugPrint("開始使用 GROUPING");
                    Navigator.pushNamed(context, '/login');
                  }
                },
                style: buttonStyle, 
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text("前往工作區", textAlign: TextAlign.center,)),
                  ],
              )),
            ),
          ],
        ),
      )
    );
    return Scaffold(
      body: BackGroundContainer(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if(constraints.maxWidth > 650){
              return AuthViewFrame(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          child: Image.asset('assets/images/welcome.png', fit: BoxFit.values[4]))
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: loginFrame,
                    ),
                  ],
                )
              );
            }
            else{
              return Container(
                color: AppColor.surface(context).withOpacity(0.5),
                child: loginFrame);
            }
          }
        ),
        ),
    );
  }
}

