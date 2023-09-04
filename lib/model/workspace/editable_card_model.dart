// create event & mission super class or activity parent class?
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/workspace/data_model.dart';

abstract class EditableCardModel extends BaseDataModel<EditableCardModel> {
  String title;
  List<String> contributorIds;
  String introduction;
  List<String> tags;
  List<DateTime> notifications;
  AccountModel ownerAccount;

  EditableCardModel(
      {this.title = 'default',
      this.contributorIds = const [],
      this.introduction = 'default',
      this.notifications = const [],
      this.tags = const [],
      required this.ownerAccount,
      super.id = '',
      super.databasePath = '',
      super.storageRequired = false});
      
  @override
  EditableCardModel fromJson({required String id, required Map<String, dynamic> data});

  @override
  Map<String, dynamic> toJson();
}
