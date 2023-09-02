

import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';
import 'package:grouping_project/View/app/auth/welcome_message_view.dart';
import 'package:grouping_project/View/theme/color.dart';
import 'package:grouping_project/View/theme/padding.dart';
import 'package:grouping_project/View/theme/text.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:grouping_project/ViewModel/auth/sign_in_view_model.dart';
import 'package:provider/provider.dart';

class WebSignInView extends StatefulWidget{
  const WebSignInView({Key? key}) : super(key: key);

  @override
  State<WebSignInView> createState() => _WebSignInViewState();
}

class _WebSignInViewState extends State<WebSignInView> {
  final textFormKey = GlobalKey<FormState>();
  final inputFieldBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gapPadding: 10
  );

  bool isPasswordVisible = true;

  Widget getInputForm(BuildContext context){
    return Consumer<SignInViewModel>(
      builder: (context, signInManager,child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: textFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical :5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "請輸入帳號名稱",
                    label: const Text("輸入帳號名稱"),
                    prefixIcon: const Icon(Icons.account_circle),
                    border: inputFieldBorder
                  ),
                  validator: signInManager.userNameValidator,
                  onChanged: (value) => signInManager.onUserNameChange(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "輸入信箱",
                    prefixIcon: const Icon(Icons.email),
                    label: const Text("輸入信箱"), 
                    border: inputFieldBorder
                  ),
                  validator: signInManager.emailValidator,
                  onChanged: (value) => signInManager.onEmailChange(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical :5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "請輸入密碼",
                    prefixIcon: const Icon(Icons.password),
                    label: const Text("輸入密碼"), 
                    border: inputFieldBorder
                  ),
                  validator: signInManager.passwordValidator,
                  onChanged: (value) => signInManager.onPasswordChange(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical :5.0),
                child: TextFormField(
                  obscureText: isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "密碼確認",
                    suffixIcon: IconButton(
                      onPressed: (){setState(() {isPasswordVisible = !isPasswordVisible;});}, 
                      icon: isPasswordVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                    ),
                    prefixIcon: const Icon(Icons.password),
                    label: const Text("密碼確認"), 
                    border: inputFieldBorder
                  ),
                  validator: signInManager.passwordConfirmValidator,
                  onChanged: (value) => signInManager.onPasswordConfirmChange(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: (){
                    if(textFormKey.currentState!.validate()){
                      debugPrint("註冊成功");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeView()));
                    }
                  },
                  style: buttonStyle,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Text("註冊", textAlign: TextAlign.center,)),
                    ],
                )),
              ),
              
              TextButton(onPressed: (){
                debugPrint("前往登入畫面");
                Navigator.pushNamed(context, '/login');
              }, child: Text("已經有帳號了？ 點我登入", style: TextStyle(color: AppColor.secondary(context)),))
          ],
          ),
        ),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    Widget loginFrame = Center(
      child: AppPadding.large(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWithContent(
              title: "註冊 Sign In", 
              content: "加入Grouping，註冊新的Grouping 帳號"
            ),
            const Divider(thickness: 2),
            getInputForm(context),
          ],
        ),
      )
    );
    return ChangeNotifierProvider(
      create: (context) => SignInViewModel(),
      child: Scaffold(
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
                          child: Image.asset('assets/images/login.png', fit: BoxFit.values[4])
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
      ),
    );
  }
}

