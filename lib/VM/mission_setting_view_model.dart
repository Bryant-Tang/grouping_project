import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';

class MissionSettingViewModel extends ChangeNotifier {
  MissionModel missionModel = MissionModel();
  AccountModel creatorAccount = AccountModel();
  List<AccountModel> contributorAccountModelList = [];
  bool forUser = true;

  List<MissionStateModel> inProgress = [];
  List<MissionStateModel> pending = [];
  List<MissionStateModel> close = [];

  // String newStateModel
  AccountModel get missionOwnerAccount => missionModel.ownerAccount;
  String get introduction => missionModel.introduction;
  String get title => missionModel.title;
  String get ownerAccountName => missionOwnerAccount.nickname;
  DateTime get missionDeadline => missionModel.deadline;
  MissionStateModel get missionState => missionModel.state;
  // Color get stateColor =>
  String get missionStateName => missionState.stateName;
  Map<MissionStage, Color> stageColorMap = {
    MissionStage.progress: Colors.blue,
    MissionStage.pending: Colors.red,
    MissionStage.close: Colors.green,
  };

  DateFormat dataformat = DateFormat('h:mm a, MMM d, y');
  String get formattedDeadline => dataformat.format(missionDeadline);
  Color get color => Color(missionOwnerAccount.color);

  List<AccountModel> contributorProfile = [];
  List<AccountModel> get contributors => contributorProfile;
  List<AccountModel> get groupMember => creatorAccount.associateEntityAccount;
  List<AccountModel> get contributor => contributorAccountModelList;
  MissionStateModel get stateModel => missionModel.state;
  bool isLoading = true;

  // bool get forUser => isPersonal;
  // MissionSettingViewModel(this.missionModel, this.settingMode);

  // model.getAllState();
  // model.updateState(MissionStage.progress, 'in progress');

  void updateTitle(String newTitle) {
    missionModel.title = newTitle;
    notifyListeners();
  }

  String? titleValidator(value) {
    return title.isEmpty ? '不可為空' : null;
  }

  void updateIntroduction(String newIntro) {
    missionModel.introduction = newIntro;
    notifyListeners();
  }

  String? introductionValidator(value) {
    return introduction.isEmpty ? '不可為空' : null;
  }

  String getTimerCounter() {
    String output = "";
    Duration duration;
    final currentTime = DateTime.now();
    if (currentTime.isBefore(missionDeadline)) {
      output = '即將到來-還有';
      duration = missionDeadline.difference(currentTime);
    } else {
      return '活動已結束';
    }
    final days = duration.inDays.toString();
    final hours = (duration.inHours % 24).toString();
    final minutes = (duration.inMinutes % 60).toString();
    final seconds = (duration.inSeconds % 60).toString();
    return '$output ${days.padLeft(2, '0')} D ${hours.padLeft(2, '0')} H ${minutes.padLeft(2, '0')} M ${seconds.padLeft(2, '0')} S';
  }

  void updateDeadline(DateTime newTime) {
    missionModel.deadline = newTime;
    notifyListeners();
  }

  void addContributors(String newContributorId) {
    missionModel.contributorIds.add(newContributorId);
    notifyListeners();
  }

  void removeContributors(String removedContributorId) {
    missionModel.contributorIds.remove(removedContributorId);
    notifyListeners();
  }

  void updateState(MissionStateModel newState) {
    missionModel.setStateByStateModel(newState);
    notifyListeners();
  }

  void createState(MissionStage newStage, String newStateName) async {
    // TODO: 沒有及時刷新
    await DatabaseService(
            ownerUid: forUser ? AuthService().getUid() : creatorAccount.id!,
            forUser: forUser)
        .setMissionState(
            state: MissionStateModel(stage: newStage, stateName: newStateName));
    getAllState();
    notifyListeners();
  }

  void deleteStateName(
      MissionStage selectedStage, String selectedStateName) async {
    MissionStateModel beDeleted;
    if (selectedStage == MissionStage.progress) {
      beDeleted = inProgress
          .firstWhere((element) => element.stateName == selectedStateName);
    } else if (selectedStage == MissionStage.pending) {
      beDeleted = pending
          .firstWhere((element) => element.stateName == selectedStateName);
    } else if (selectedStage == MissionStage.close) {
      beDeleted =
          close.firstWhere((element) => element.stateName == selectedStateName);
    } else {
      beDeleted = MissionStateModel();
    }
    if (stateModel.stateName == selectedStateName) {
      String name = '';
      if (selectedStage == MissionStage.progress) {
        name = 'in progress';
      } else if (selectedStage == MissionStage.pending) {
        name = 'pending';
      } else if (selectedStage == MissionStage.close) {
        name = 'finish';
      } else {}
      // updateState(selectedStage, name);
    }
    await DatabaseService(
            ownerUid: forUser ? AuthService().getUid() : creatorAccount.id!,
            forUser: forUser)
        .deleteMissionState(beDeleted);
    getAllState();
    notifyListeners();
  }

  Future<void> getAllState() async {
    debugPrint(missionOwnerAccount.id!);
    final allState =
        await DatabaseService(ownerUid: missionOwnerAccount.id!, forUser: false)
            .getAllMissionState();
    inProgress = List.from(
        allState.where((state) => state.stage == MissionStage.progress));
    // inProgress = List.generate(inProgressIndexs.length, (index) => allState[index]);
    pending = List.from(
        allState.where((state) => state.stage == MissionStage.pending));
    close =
        List.from(allState.where((state) => state.stage == MissionStage.close));
    // close = List.generate(inCloseIndexs.length, (index) => allState[index]);
    // for (MissionStateModel state in allState) {
    //   debugPrint('${state.stateName}');
    // }
    notifyListeners();
  }

  // Future<bool> onSave() async {
  //   if (title.isEmpty ||
  //       introduction.isEmpty ||
  //       deadline.isBefore(DateTime.now())) {
  //     return false;
  //   } else if (settingMode == SettingMode.create) {
  //     await DatabaseService(
  //             ownerUid: forUser ? AuthService().getUid() : creatorAccount.id!,
  //             forUser: forUser)
  //         .setMission(mission: missionModel);
  //     // Create Event
  //   } else if (settingMode == SettingMode.edit) {
  //     await DatabaseService(
  //             ownerUid: forUser ? AuthService().getUid() : creatorAccount.id!,
  //             forUser: forUser)
  //         .setMission(mission: missionModel);
  //     // Edit Event
  //   } else {}
  //   return true;
  // }

  // String errorMessage() {
  //   if (title.isEmpty) {
  //     return 'Title 不能為空';
  //   } else if (introduction.isEmpty) {
  //     return 'Introduction 不能為空';
  //   } else if (deadline.isBefore(DateTime.now())) {
  //     return '截止時間不可在現在時間之前';
  //   } else {
  //     return 'unknown error';
  //   }
  // }

  Future<void> initializeNewMission(
      {required AccountModel creatorAccount,
      required AccountModel ownerAcount}) async {
    this.creatorAccount = creatorAccount;
    // debugPrint('owner ${this.creatorAccount.id}');
    missionModel = MissionModel(
      deadline: DateTime.now().add(const Duration(hours: 1)),
      title: '任務標題',
      introduction: '任務介紹',
      contributorIds: [creatorAccount.id!],
    );
    missionModel.ownerAccount = ownerAcount;
    forUser = missionOwnerAccount.id! == creatorAccount.id!;
    isLoading = true;
    notifyListeners();
    await getAllState();
    missionModel.setStateByStateModel(MissionStateModel.defaultProgressState);
    debugPrint(inProgress.length.toString());
    debugPrint(pending.length.toString());
    debugPrint(close.length.toString());
    // await get all contibutor candidate
    contributorAccountModelList.add(creatorAccount);
    isLoading = false;
    notifyListeners();
  }

  Future<void> initializeDisplayMission(
      {required MissionModel model, required AccountModel user}) async {
    isLoading = true;
    missionModel = model;
    creatorAccount = user;
    // await getAllState();
    // ownerAccount = eventModel.ownerAccount;
    forUser = missionOwnerAccount.id! == creatorAccount.id!;
    addContributors(creatorAccount.id!);
    contributorAccountModelList.add(creatorAccount);
    notifyListeners();
    // eventContributoIds.add(eventOwnerAccount.id!);
    // debugPrint('ownerAccount ${eventModel.ownerAccount.nickname.toString()}');
    // debugPrint('ownerAccount ${eventModel.ownerAccount.associateEntityId.toString()}');
    // debugPrint(forUser.toString());
    // debugPrint(eventModel.associateEntityAccount.toString());
    // debugPrint(eventModel.contributorIds.toString());
    // missionOwnerAccount.associateEntityAccount = [];
    // if (forUser == false) {
    //   // get all event contributor account Profile from owner Account model associate list
    //   for (String associationEntityId in missionModel.ownerAccount.associateEntityId) {
    //     eventModel.ownerAccount.associateEntityAccount.add(
    //         await DatabaseService(ownerUid: associationEntityId, forUser: false)
    //             .getAccount());
    //   }
    //   for (AccountModel candidateAccountModel in contributorCandidate) {
    //     if (eventContributoIds.contains(candidateAccountModel.id!)) {
    //       contributorAccountModel.add(candidateAccountModel);
    //     }
    //   }
    // // debugPrint(contributorAccountModel.length.toString());
    // for (String contributorId in eventContributoIds) {
    //   contributorAccountModel
    //       .add(await DatabaseService(ownerUid: contributorId).getAccount());
    // }
    // } else {
    //   missionOwnerAccount.associateEntityAccount.add(creatorAccount);
    // }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createMission() async {
    // debugPrint("on save ${missionModel.contributorIds.toString()}");
    // debugPrint("on save ${missionOwnerAccount.id}");
    // debugPrint("deadline $missionDeadline");
    await DatabaseService(ownerUid: missionOwnerAccount.id!, forUser: false)
        .setMission(mission: missionModel);
    notifyListeners();
  }

  // Future<void> editMission() async {
  //   // edit event with eventData
  //   // debugPrint("on save ${missionModel.contributorIds.toString()}");
  //   // debugPrint("deadline $missionDeadline");
  //   // TODO: Change to owner account
  //   await DatabaseService(ownerUid: missionOwnerAccount.id!, forUser: false)
  //       .setMission(mission: missionModel);
  //   notifyListeners();
  // }

  Future<void> deleteMission() async {
    await DatabaseService(ownerUid: missionOwnerAccount.id!, forUser: false)
        .deleteMission(missionModel);
    notifyListeners();
  }
}
