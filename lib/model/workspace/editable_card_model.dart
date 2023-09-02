// create event & mission super class or activity parent class?
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/workspace/data_model.dart';
import 'package:meta/meta.dart';

class EditableCardModel extends BaseDataModel<EditableCardModel> {
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

  @mustBeOverridden
  EditableCardModel fromFirestore(
      {required String id, required Map<String, dynamic> data}) {
    // TODO: implement fromFirestore
    throw UnimplementedError();
  }

  @mustBeOverridden
  Map<String, dynamic> toFirestore() {
    // TODO: implement toFirestore
    throw UnimplementedError();
  }
}
