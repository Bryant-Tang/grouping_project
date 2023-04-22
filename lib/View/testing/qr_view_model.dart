import 'package:flutter/foundation.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRViewModel extends ChangeNotifier {
  bool onShow = false;
  bool onScan = false;
  String stringToShow = '';
  String welcomeMessage = '';
  String code = '';
  late AccountModel groupAccountModel;
  late AccountModel personalAccountModel;

  void showGroupId(String? toShow) {
    stringToShow = toShow ?? '';
  }

  void updateBarcode(String barcode) {
    code = barcode;
    notifyListeners();
  }

  /// for notifyListeners() to not work when building
  bool isInit() {
    return (!onShow && !onScan);
  }

  void updateWelcomeMessage(String message) {
    welcomeMessage = message;
  }

  Future<void> setGroupModel() async {
    groupAccountModel =
        await DatabaseService(ownerUid: code, forUser: false).getAccount();
    notifyListeners();
  }

  void setPersonalModel(AccountModel accountModel) {
    personalAccountModel = accountModel;
  }

  void addAssociation() {
    if (groupAccountModel.id != null && personalAccountModel.id != null) {
      groupAccountModel.addEntity(personalAccountModel.id!);
      personalAccountModel.addEntity(groupAccountModel.id!);
      notifyListeners();
    }
  }
}
