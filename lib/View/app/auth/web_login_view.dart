

import 'package:flutter/material.dart';
import 'package:grouping_project/View/theme/color.dart';
import 'package:grouping_project/View/theme/padding.dart';
import 'package:grouping_project/View/theme/text.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class WebLoginView extends StatefulWidget{
  const WebLoginView({Key? key}) : super(key: key);

  @override
  State<WebLoginView> createState() => _WebLoginViewState();
}

class _WebLoginViewState extends State<WebLoginView> {
  final String googleIconPath = "assets/icons/authIcon/google.png";

  final String gitHubIconPath = "assets/icons/authIcon/github.png";

  final String lineIconPath = "assets/icons/authIcon/line.png";

  final textFormKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  Widget getInputForm(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: textFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "請輸入帳號",
                label: Text("輸入帳號"),
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gapPadding: 10
                )
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                hintText: "請輸入密碼",
                suffixIcon: IconButton(
                  onPressed: (){setState(() {isPasswordVisible = !isPasswordVisible;});}, 
                  icon: isPasswordVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                ),
                prefixIcon: const Icon(Icons.password),
                label: const Text("輸入密碼"), 
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gapPadding: 10
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: (){
                  if(textFormKey.currentState!.validate()){
                    debugPrint("登入成功");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text("登入", textAlign: TextAlign.center,)),
                  ],
              )),
            ),
            TextButton(onPressed: (){
              debugPrint("前往註冊畫面");
            }, child: const Text("沒有帳號密碼嗎？ 點我註冊"))
        ],
        ),
      ),
    );
  }

  Widget thirdPartyLabel(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(child: Divider(thickness: 2)),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("第三方登入", textAlign: TextAlign.center, style: AppText.labelLarge(context).copyWith(
            color: AppColor.onSurface(context).withOpacity(0.5),
            // fontWeight: FontWeight.bold
          ),),
        )),
        const Expanded(child: Divider(thickness: 2)),
      ],
    );
  }

  Widget thirdPartyLoginList(BuildContext context){
    // TODO: implement on pressed method
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        thirdPartyLoginButton(
          color: Colors.blue,
          iconPath: googleIconPath,
          onPressed: (){}
        ),
        thirdPartyLoginButton(
          color: Colors.purple,
          iconPath: gitHubIconPath,
          onPressed: (){}
        ),
        thirdPartyLoginButton(
          color: Colors.green,
          iconPath: lineIconPath,
          onPressed: (){}
        ),
      ],
    );
  }

  Widget thirdPartyLoginButton({required Color color,required String iconPath, required VoidCallback onPressed}){
    return SizedBox(
      width: 52,
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          onPressed: onPressed, 
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(4.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: color.withOpacity(0.3), width: 2)
            )
          ),
          child: SizedBox.square (
            dimension: 28,
            child: Image.asset(iconPath, fit: BoxFit.cover))
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGroundContainer(
        child: AuthViewFrame(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Consumer<ThemeManager>(
                    builder: (context, themeManager, child) => themeManager.coverLogo,
                  )
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: AppPadding.large(
                    // padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("登入 Login", style: AppText.titleLarge(context)),
                        Text("利用Email 登入或第三方登入", style: AppText.titleSmall(context).copyWith(
                          color: AppColor.onSurface(context).withOpacity(0.5)

                        )),
                        const Divider(thickness: 2),
                        getInputForm(context),
                        thirdPartyLabel(context),
                        thirdPartyLoginList(context)
                      ],
                    ),
                  )
                ),
              ),
            ],
          )
          ),
        ),
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
          AppColor.surface(context).withOpacity(0.95),
          BlendMode.screen
        ), 
        image: const AssetImage('assets/images/cover.png'),
        fit: BoxFit.values[4]
      ),
    ),
    child: child ?? const SizedBox.shrink(),
    );
  }
}

class AuthViewFrame extends StatelessWidget{
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
                offset: const Offset(0, 0)
              )
            ]
          ),
          child: AspectRatio(
            aspectRatio: 1.3,
            child: child ?? const SizedBox.shrink(),
          )
        )
      ),
    );
  }
}