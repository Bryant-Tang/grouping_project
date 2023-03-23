import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/profile/profile_info.dart';
import 'package:grouping_project/pages/profile/profile_photo_upload.dart';
import 'package:grouping_project/pages/profile/profile_tag_edit.dart';

class ProfileInherited extends InheritedWidget {
  final Widget child;
  final ProfileModel profile;
  const ProfileInherited(
      {super.key, required this.profile, required this.child})
      : super(child: child);

  // static ProfileInherited? maybeOf(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<ProfileInherited>();
  // }

  static ProfileInherited? of(BuildContext context) {
    // final ProfileInherited? result = maybeOf(context);
    // assert(result != null, 'No ProfileInherited found in context');
    // return result!;
    return context.dependOnInheritedWidgetOfExactType<ProfileInherited>();
  }

  @override
  bool updateShouldNotify(ProfileInherited oldWidget) {
    return oldWidget.profile != profile;
  }
}

class EditPersonalProfilePage extends StatefulWidget {
  const EditPersonalProfilePage({super.key});

  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  late final PerosonalProfileSetting personalProfileSetting;
  late final PersonalProfileTagSetting personalProfileTagSetting;
  late final PersonProfileImageUpload personalProfileImageUpload;
  final _dataController = DataController();
  TabController? _tabController;
  int _currentPageIndex = 0;
  late final List<Widget> _pages;
  ProfileModel profile = ProfileModel();

  // List<Map<String, String>> getTagTable() {
  //   return [
  //     // {"key": "學校", "value": "國立中央大學"},
  //     // {"key": "生日", "value": "91/07/15"},
  //     // {"key": "號碼", "value": "0987685806"},
  //     // {"key": "號碼", "value": "0987685806"},
  //   ];
  // }

  @override
  void initState() {
    super.initState();
    _dataController
        .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        .then((value) {
      debugPrint(value.toString());
      setState(() {
        profile = value;
      });
    });
    personalProfileSetting = PerosonalProfileSetting();
    personalProfileTagSetting = PersonalProfileTagSetting();
    personalProfileImageUpload = PersonProfileImageUpload();
    _pages = [
      personalProfileSetting,
      personalProfileTagSetting,
      personalProfileImageUpload
    ];
    _tabController = TabController(length: 3, vsync: this);
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
        _tabController!.index = _currentPageIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProfileInherited(
      profile: profile,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 30),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _pages,
              ),
            ),
            SizedBox(
              height: 60.0,
              child: Center(
                child: TabPageSelector(
                  controller: _tabController,
                  color: Colors.white,
                  selectedColor: Colors.amber,
                  indicatorSize: 16,
                ),
              ),
            ),
            NavigationToggleBar(
                goBackButtonText: "Cancel",
                goToNextButtonText: "Save",
                goToNextButtonHandler: () {
                  setState(() {
                    debugPrint(
                        personalProfileImageUpload.profileImage.toString());
                    profile.slogan =
                        personalProfileSetting.content!['userMotto'];
                    profile.name = personalProfileSetting.content!['userName'];
                    profile.nickname =
                        personalProfileSetting.content!['userRealName'];
                    profile.introduction =
                        personalProfileSetting.content!['userInroduction'];
                    profile.tags = personalProfileTagSetting.tagTable;
                    profile.photo = personalProfileImageUpload.profileImage;
                    _dataController
                        .upload(uploadData: profile)
                        .then((value) => debugPrint('upload successfully'));
                  });
                  Navigator.of(context).pop();
                },
                goBackButtonHandler: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    ));
  }
}
