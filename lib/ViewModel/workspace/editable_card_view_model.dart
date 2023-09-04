import 'package:flutter/material.dart';
import 'package:grouping_project/model/auth/auth_model_lib.dart';
import 'package:grouping_project/model/workspace/editable_card_model.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
// import 'package:grouping_project/model/workspace/data_model.dart';
// import 'package:grouping_project/model/event_model.dart';
// import 'package:intl/intl.dart';


class EditableCardViewModel<T extends EditableCardModel> extends ChangeNotifier{
  // EditableCard 的擁有者, group or people Account。
  // AccountModel ownerAccount = AccountModel();
  // EditableCard 的創建者, 只有在第一次create的時候有用。
  // AccountModel creatorAccount = AccountModel();

  // T model = T();

  // DateFormat dataformat = DateFormat('h:mm a, MMM d, y');

  // // getter
  // AccountModel get eventOwnerAccount => model.ownerAccount;
  // String get title => model.title; // Event title
  // String get introduction => model.introduction; // Introduction od event
  // String get ownerAccountName =>
  //     eventOwnerAccount.name; // event owner account name
  // Color get color => Color(model.ownerAccount.color);
}