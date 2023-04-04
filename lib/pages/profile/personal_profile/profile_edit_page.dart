import 'package:flutter/material.dart';
import 'package:googleapis/mybusinessbusinessinformation/v1.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_info.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_photo_upload.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_tag_edit.dart';

class InheritedProfile extends InheritedWidget {
  final ProfileModel profile;
  const InheritedProfile(
      {super.key, required this.profile, required Widget child})
      : super(child: child);

  static InheritedProfile? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedProfile>();
  }

  @override
  bool updateShouldNotify(InheritedProfile oldWidget) {
    return oldWidget.profile != profile;
  }
}

class EditPersonalProfilePage extends StatefulWidget {
  final ProfileModel profile;
  const EditPersonalProfilePage({super.key, required this.profile});

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
  // ProfileModel profile = ProfileModel();

  @override
  void initState() {
    super.initState();
    debugPrint("INIT");
    debugPrint(widget.profile.name);
    debugPrint(widget.profile.nickname);
    debugPrint(widget.profile.introduction);
    debugPrint(widget.profile.slogan);
    debugPrint(widget.profile.tags.toString());
    debugPrint(widget.profile.photo.toString());
    personalProfileSetting = PerosonalProfileSetting();
    personalProfileTagSetting = PersonalProfileTagSetting(
      tagTable: widget.profile.tags??[],
    );
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
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: InheritedProfile(
            profile: widget.profile,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
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
                          widget.profile.name =
                              personalProfileSetting.profile.name;
                          widget.profile.nickname =
                              personalProfileSetting.profile.nickname;
                          widget.profile.slogan =
                              personalProfileSetting.profile.slogan;
                          widget.profile.introduction =
                              personalProfileSetting.profile.introduction;
                          widget.profile.tags =
                              personalProfileTagSetting.tagTable;
                          widget.profile.photo =
                              personalProfileImageUpload.profileImage;
                          // debugPrint all profile data
                          debugPrint("SAVE");
                          debugPrint(widget.profile.name);
                          debugPrint(widget.profile.nickname);
                          debugPrint(widget.profile.introduction);
                          debugPrint(widget.profile.slogan);
                          debugPrint(widget.profile.tags.toString());
                          debugPrint(widget.profile.photo.toString());
                        });
                        _dataController
                            .upload(uploadData: widget.profile)
                            .then((value) => debugPrint('upload successfully'));
                        Navigator.of(context).pop();
                      },
                      goBackButtonHandler: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
