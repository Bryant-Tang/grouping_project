// import 'package:flutter/foundation.dart';
// import 'package:grouping_project/model/auth/auth_model_lib.dart';
// import 'package:grouping_project/service/service_lib.dart';

// class QRViewModel extends ChangeNotifier {
//   bool onShow = false;
//   bool onScan = false;
//   String stringToShow = '';
//   String welcomeMessage = '';
//   String code = '';
//   bool isShare = false;
//   bool isScanner = false;
//   late AccountModel groupAccountModel;
//   late AccountModel personalAccountModel;

//   void showGroupId(String? toShow) {
//     stringToShow = toShow ?? '';
//   }

//   void updateBarcode(String barcode) {
//     code = barcode;
//     if (code != 'https://reurl.cc/EG3gy1') {
//       //TODO: Open the video
//     }
//     notifyListeners();
//   }

//   /// for notifyListeners() to not work when building
//   bool isInit() {
//     return (!onShow && !onScan);
//   }

//   void updateWelcomeMessage(String message) {
//     welcomeMessage = message;
//   }

//   Future<void> setGroupModel() async {
//     groupAccountModel =
//         await DatabaseService(ownerUid: code, forUser: false).getAccount();
//     notifyListeners();
//   }

//   void setPersonalModel(AccountModel accountModel) {
//     personalAccountModel = accountModel;
//   }

//   void addAssociation() {
//     if (groupAccountModel.id != null && personalAccountModel.id != null) {
//       groupAccountModel.addEntity(personalAccountModel.id!);
//       personalAccountModel.addEntity(groupAccountModel.id!);
//       notifyListeners();
//     }
//   }

//   void setShareIndicator({bool? targetIndicator, bool fromSetScanner = false}) {
//     isShare = targetIndicator ?? !isShare;
//     if (!fromSetScanner) {
//       setScannerIndicator(targetIndicator: false, fromSetShare: true);
//     }
//     notifyListeners();
//   }

//   void setScannerIndicator({bool? targetIndicator, bool fromSetShare = false}) {
//     isScanner = targetIndicator ?? !isScanner;
//     if (!fromSetShare) {
//       setShareIndicator(targetIndicator: false, fromSetScanner: true);
//     }
//     notifyListeners();
//   }
// }
