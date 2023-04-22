import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/database_service.dart';
import 'package:grouping_project/model/account_model.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService().emailLogIn('test@mail.com', 'password');

  var databaseService = DatabaseService(ownerUid: AuthService().getUid());

  String accountId = await databaseService.createUserAccount();
  AccountModel testAccount = AccountModel(
      accountId: accountId,
      name: 'test user',
      email: 'test@mail.com',
      associateEntityId: ['1']);
  databaseService.setAccount(account: testAccount);
  debugPrint('123');
  var testData = await databaseService.getAccount();
  debugPrint(testData.associateEntityAccount is Iterable
      ? testData.associateEntityAccount[0].name
      : null);
}
