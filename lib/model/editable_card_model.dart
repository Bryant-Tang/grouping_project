// create event & mission super class or activity parent class?
import 'package:grouping_project/model/data_model.dart';
import 'package:meta/meta.dart';

class EditableCardModel extends BaseDataModel<EditableCardModel> {
  String title;
  List<String> contributorIds;
  String introduction;
  List<String> tags;
  List<DateTime> notifications;

  EditableCardModel(
      {this.title = 'default',
      this.contributorIds = const [],
      this.introduction = 'default',
      this.notifications = const [],
      this.tags = const [],
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
