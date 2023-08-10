import 'package:grouping_project/service/auth/auth_service.dart';

class AccountAuth {
  late String account;
  late String password;

  AccountAuth();
  Future signIn() async {
    AuthWithBackEndService.authWithAcccountAndPassword(
        account: account, password: password);
  }
}
