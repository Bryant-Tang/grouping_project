import 'package:meta/meta.dart';
class DataModel {
  

  DataModel();

  
  Future<void> setMethod({required var data}) async {
    return;
  }

  Future<void> updateMethod({required var data}) async {
    return;
  }

  Future<Object> getMethod({required var id}) async {
    return Object();
  }
}

class EventModel extends DataModel {
  String? data;
  EventModel({this.data});

  @override
  Future<void> setMethod({required var data}) async {
    return;
  }
}
